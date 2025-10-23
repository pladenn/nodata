package com.pladen.adapter.impl.sql;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.pladen.adapter.DataProviderInput;
import com.pladen.dto.Parameter;
import com.pladen.service.CommonHelper;
import lombok.SneakyThrows;
import org.apache.commons.lang3.tuple.Pair;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.IntStream;

import static com.pladen.entity.DataType.*;
import static java.util.stream.Collectors.toList;

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
                           string_value text,
                           uuid_value uuid,
                           boolean_value bool,
                           integer_value integer
                      );
            
                truncate sql_block_parameters;
            END $$
            """;

    private static final String INSERT_SQL_BLOCK_PARAMETER = """
            insert into sql_block_parameters values(:name, :type, :string_value, :uuid_value, :boolean_value)
            """;

    public SqlDataProvider(CommonHelper commonHelper) {
        this.commonHelper = commonHelper;

        //todo remove
        this.okResult = commonHelper.message("ok!");

        this.okResult1 = commonHelper.textMessage("ok!");
    }

    @Transactional
    @Override
    public Pair<List<String>, JsonNode> getData(DataProviderInput input) {
        final SqlInput sqlInput = new SqlInput(input);

        final NamedParameterJdbcTemplate template = getNamedParameterJdbcTemplate(sqlInput);

        final String query = input.getExecutionContext().populatePlaceholders(sqlInput.getQuery());

        if ("SQL_DML".equals(sqlInput.getMethod())) {
            final int modified = template
                    .update(query, prepareQueryParams(sqlInput.getParameters()));

            if (modified < 1) {
                throw new RuntimeException("Nothing is modified");
            }

            return okResult1;
        } else if ("SQL_BLOCK".equals(sqlInput.getMethod())) {
            prepareSqlBlockParameters(sqlInput.getParameters(), template);
            template.getJdbcTemplate().execute(query);

            return okResult1;
        } else {
            return template
                    .query(query, prepareQueryParams(sqlInput.getParameters()), this::mapResultSet1);
        }
    }

    private void prepareSqlBlockParameters(List<Parameter> parameters, NamedParameterJdbcTemplate template) {
        template.getJdbcTemplate().execute(SQL_BLOCK_PARAMETERS_TABLE);

        parameters.forEach(parameter -> {
            final MapSqlParameterSource queryParams = new MapSqlParameterSource();

            queryParams.addValue("name", parameter.getName());
            queryParams.addValue("type", parameter.getType().name());

            queryParams.addValue("string_value",
                    (parameter.getType() == STRING || parameter.getType() == TEXT) ? parameter.getValue() : null);

            queryParams.addValue("uuid_value",
                    parameter.getType() == UUID ? parameter.getType().fromString(parameter.getValue()) : null);

            queryParams.addValue("boolean_value",
                    parameter.getType() == BOOLEAN ? parameter.getType().fromString(parameter.getValue()) : null);

            queryParams.addValue("integer_value",
                    parameter.getType() == INTEGER ? parameter.getType().fromString(parameter.getValue()) : null);

            template.update(INSERT_SQL_BLOCK_PARAMETER, queryParams);

        });
    }

    //todo remove
    @SneakyThrows
    private Pair<List<String>, List<Map<String, String>>> mapResultSet(ResultSet resultSet) {
        final ResultSetMetaData metaData = resultSet.getMetaData();

        final List<String> columns = IntStream.iterate(1, n -> n + 1)
                .limit(metaData.getColumnCount())
                .mapToObj(n -> getColumnName(metaData, n))
                .collect(toList());

        final List<Map<String, String>> data = new LinkedList<>();

        while (resultSet.next()) {
            data.add(
                    IntStream.iterate(1, n -> n + 1)
                            .limit(metaData.getColumnCount())
                            .boxed()
                            .collect(
                                    HashMap::new,
                                    (m, index) -> m.put(
                                            getColumnName(metaData, index),
                                            getColumnValue(resultSet, index)
                                            ),
                                    Map::putAll)
            );

        }

        return Pair.of(columns, data);
    }

    @SneakyThrows
    private Pair<List<String>, JsonNode> mapResultSet1(ResultSet resultSet) {
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

