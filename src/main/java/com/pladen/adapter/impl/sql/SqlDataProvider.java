package com.pladen.adapter.impl.sql;

import static com.pladen.dto.ExecutionContext.__VARIABLES;
import static com.pladen.entity.DataType.DATE;
import static com.pladen.entity.DataType.STRING;
import static com.pladen.entity.DataType.TEXT;
import static com.pladen.entity.DataType.values;
import static java.util.stream.Collectors.joining;
import static java.util.stream.Collectors.toList;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.pladen.adapter.DataProviderInput;
import com.pladen.dto.ExecutionContext;
import com.pladen.dto.Parameter;
import com.pladen.service.CommonHelper;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.stream.IntStream;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.tuple.Pair;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.datasource.SingleConnectionDataSource;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Component
public class SqlDataProvider extends AbstractSqlDataProvider {
    private final Pair<List<String>, List<Map<String, String>>> okResult;
    private final Pair<List<String>, JsonNode> okResult1 ;
    private final CommonHelper commonHelper;
    private static final String SQL_BLOCK_PARAMETERS_TABLE = """
            DO $$
            BEGIN
                CREATE TEMPORARY TABLE if not exists sql_block_parameters(
                           name varchar(50),
                           type varchar(50),
                           from_request boolean,
                           %s
                      );
            
                truncate sql_block_parameters;
            END $$
            """.formatted(
            Arrays.stream(values())
                    .filter(type -> TEXT != type)
                    .map(type -> type.name().toLowerCase() + "_value " + type.getSqlDataType())
                    .collect(joining(", "))
    );

    private static final String RESULT_PARAMETER_NAME = "__result";

    private static final String SELECT_SQL_BLOCK_RESULT = """
            select string_value from sql_block_parameters where name = '%s'
            """.formatted(RESULT_PARAMETER_NAME);

    private static final String INSERT_SQL_BLOCK_PARAMETER = """
            insert into sql_block_parameters(name, type, from_request, %s) values(:name, :type, :from_request, %s)
            """.formatted(
            Arrays.stream(values())
                    .filter(type -> TEXT != type)
                    .map(Enum::name)
                    .map(String::toLowerCase)
                    .map(type -> type + "_value")
                    .collect(joining(", ")),

            Arrays.stream(values())
                    .filter(type -> TEXT != type)
                    .map(Enum::name)
                    .map(String::toLowerCase)
                    .map(type -> ":" + type + "_value")
                    .collect(joining(", "))
    );

    public SqlDataProvider(CommonHelper commonHelper) {
        this.commonHelper = commonHelper;

        //todo remove
        this.okResult = commonHelper.message("ok!");

        this.okResult1 = commonHelper.textMessage("ok!");
    }

    @Transactional
    @Override
    public Pair<List<String>, JsonNode> getData(DataProviderInput input, boolean loggingEnabled) {
        final SqlInput sqlInput = new SqlInput(input);
        final ExecutionContext inputContext = input.getExecutionContext();

        final NamedParameterJdbcTemplate template = getNamedParameterJdbcTemplate(sqlInput);

        final String query = inputContext.populatePlaceholders(sqlInput.getQuery());

        if (loggingEnabled) {
            inputContext.logLineWithSeparators(logQueryWithParameters(query, sqlInput.getParameters()));
        }

        if ("SQL_DML".equals(sqlInput.getMethod())) {
            final MapSqlParameterSource params = prepareQueryParams(sqlInput.getParameters());
            addVariables(sqlInput, params);

            final int modified = template.update(query, params);

            if (modified < 1) {
                throw new RuntimeException("Nothing is modified");
            }

            return okResult1;
        } else if ("SQL_BLOCK".equals(sqlInput.getMethod())) {
            return executeSqlBlock(sqlInput.getParameters(), template, query);
        } else {
          final MapSqlParameterSource params = prepareQueryParams(sqlInput.getParameters());
          addVariables(sqlInput, params);

          // Enforce read-only at the JDBC/Postgres level, not by inspecting the query text -- this
          // rejects any write however it's disguised (e.g. a data-modifying CTE with RETURNING).
          // The connection is pooled per (url, login) in AbstractSqlDataProvider, so both flags MUST
          // be reset before the connection goes back to the pool. Must run the query through a
          // NamedParameterJdbcTemplate pinned to THIS SAME connection (SingleConnectionDataSource) --
          // otherwise template.query() below can pull a different pooled connection that never had
          // setReadOnly(true) applied, silently defeating the whole check (same hazard executeSqlBlock
          // already works around above).
          // Pg's JDBC driver only actually enforces setReadOnly(true) against an explicit transaction
          // (autoCommit=false + a real BEGIN) -- under Hikari's default autoCommit=true every statement
          // is its own implicit transaction and the driver never attaches the hint to anything sent to
          // Postgres, so the read-only flag is silently a no-op unless autoCommit is turned off here too.
          return template.getJdbcTemplate().execute((Connection con) -> {
              final boolean originalAutoCommit = con.getAutoCommit();
              con.setAutoCommit(false);
              con.setReadOnly(true);
              try {
                  final NamedParameterJdbcTemplate readOnlyTemplate =
                          new NamedParameterJdbcTemplate(new SingleConnectionDataSource(con, true));
                  final Pair<List<String>, JsonNode> result = readOnlyTemplate.query(query, params, this::mapResultSet);
                  con.commit();
                  return result;
              } catch (Exception e) {
                  con.rollback();
                  throw e;
              } finally {
                  con.setReadOnly(false);
                  con.setAutoCommit(originalAutoCommit);
              }
          });
        }
    }

    private void addVariables(SqlInput sqlInput, MapSqlParameterSource params) {
      sqlInput.getParameters()
          .stream()
          .map(Parameter::getName)
          .filter(__VARIABLES::contains)
          .findAny()
          .ifPresent(ignore -> params.addValue(__VARIABLES, sqlInput.getVariables()));
    }

    private String logQueryWithParameters(String query, List<Parameter> parameters) {
        String queryForLogging = "\n>>> SQL QUERY:\n\n" + query + "\n";

        for (Parameter parameter : parameters) {
            queryForLogging = queryForLogging.replaceAll(":" + parameter.getName() + "\\b",
                parameter.getType() == TEXT || parameter.getType() == STRING || parameter.getType() == DATE
                    ? parameter.getValue() == null ? "null" : Matcher.quoteReplacement("'" + parameter.getValue() + "'")
                    : parameter.getValue() == null ? "null" : parameter.getValue());
        }

        log.info(queryForLogging);
        return queryForLogging;
    }

    // sql_block_parameters is a per-connection temp table, so every statement below must share one physical connection.
    private Pair<List<String>, JsonNode> executeSqlBlock(List<Parameter> parameters, NamedParameterJdbcTemplate template, String query) {
        return template.getJdbcTemplate().execute((Connection con) -> {
            final NamedParameterJdbcTemplate blockTemplate =
                    new NamedParameterJdbcTemplate(new SingleConnectionDataSource(con, true));

            prepareSqlBlockParameters(parameters, blockTemplate);
            blockTemplate.getJdbcTemplate().execute(query);

            return fetchSqlBlockResult(blockTemplate).orElse(okResult1);
        });
    }

    // a block opts into returning data by inserting __result as a valid-JSON string_value; otherwise it's a plain "ok!"
    private Optional<Pair<List<String>, JsonNode>> fetchSqlBlockResult(NamedParameterJdbcTemplate template) {
        final List<String> results = template.getJdbcTemplate()
                .queryForList(SELECT_SQL_BLOCK_RESULT, String.class);

        if (results.isEmpty() || results.get(0) == null) {
            return Optional.empty();
        }

        final JsonNode resultNode = commonHelper.createJsonNode(results.get(0));
        // consumers expect an array-of-rows shape, so a scalar/object __result is wrapped into a one-element array
        final JsonNode data = resultNode.isArray() ? resultNode : commonHelper.createArrayNode().add(resultNode);

        return Optional.of(Pair.of(List.of(RESULT_PARAMETER_NAME), data));
    }

    private void prepareSqlBlockParameters(List<Parameter> parameters, NamedParameterJdbcTemplate template) {
        template.getJdbcTemplate().execute(SQL_BLOCK_PARAMETERS_TABLE);

        parameters.forEach(parameter -> {
            final MapSqlParameterSource queryParams = new MapSqlParameterSource();

            queryParams.addValue("name", parameter.getName());
            queryParams.addValue("type", parameter.getType().name());
            queryParams.addValue("from_request", parameter.getFromRequest());

            Arrays.stream(values())
                    .filter(type -> TEXT != type)
                    .forEach(
                            type -> queryParams.addValue(
                                    type.name().toLowerCase() + "_value",
                                    (parameter.getType() == TEXT ? STRING : parameter.getType())  == type ? type.fromString(parameter.getValue()) : null)
                    );

            template.update(INSERT_SQL_BLOCK_PARAMETER, queryParams);

        });
    }

    @SneakyThrows
    private Pair<List<String>, JsonNode> mapResultSet(ResultSet resultSet) {
        final ResultSetMetaData metaData = resultSet.getMetaData();

        final List<String> columns = IntStream.iterate(1, n -> n + 1)
                .limit(metaData.getColumnCount())
                .mapToObj(n -> getColumnName(metaData, n))
                .collect(toList());

        final ArrayNode arrayNode = commonHelper.createArrayNode();

        while (resultSet.next()) {
            final ObjectNode row = commonHelper.createObjectNode();

            IntStream.iterate(1, n -> n + 1)
                    .limit(metaData.getColumnCount())
                    .boxed()
                    .forEach(index -> put(row, resultSet, index));

            arrayNode.add(row);
        }

        return Pair.of(columns, arrayNode);
    }

    @SneakyThrows
    private String getColumnName(ResultSetMetaData metaData, int n) {
        return metaData.getColumnName(n);
    }

    @SneakyThrows
    private String getColumnValue(ResultSet resultSet, int columnIndex) {
        if (resultSet.getMetaData().getColumnTypeName(columnIndex).equals("bool")) {
            return Boolean.toString(resultSet.getBoolean(columnIndex));
        }
        return resultSet.getString(columnIndex);
    }

    @SneakyThrows
    private String put(ObjectNode row,  ResultSet resultSet, int columnIndex) {
        final String columnName = resultSet.getMetaData().getColumnName(columnIndex);

        if (resultSet.getMetaData().getColumnTypeName(columnIndex).equals("bool")) {
            row.put(columnName, resultSet.getBoolean(columnIndex));
        }
        else if (resultSet.getMetaData().getColumnTypeName(columnIndex).equals("int4")) {
            row.put(columnName, resultSet.getInt(columnIndex));
        }
        else if (resultSet.getMetaData().getColumnTypeName(columnIndex).equals("jsonb")) {
            row.set(columnName, commonHelper.createJsonNode(resultSet.getString(columnIndex)));
        }
        else {
            row.put(columnName, resultSet.getString(columnIndex));
        }
        return resultSet.getString(columnIndex);
    }

}

