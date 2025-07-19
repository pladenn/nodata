package com.pladen.adapter.impl.sql;

import com.pladen.adapter.DataProvider;
import com.pladen.dto.Parameter;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;

import javax.sql.DataSource;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

public abstract class AbstractSqlDataProvider implements DataProvider {
    private final Map<String, DataSource> dataSources = new ConcurrentHashMap<>();

    @Override
    public String getHandleType() {
        return "SQL";
    }

    final protected MapSqlParameterSource prepareQueryParams(List<Parameter> parameters) {
        final MapSqlParameterSource queryParams = new MapSqlParameterSource();
        parameters.forEach(parameter -> queryParams.addValue(
            parameter.getName(),
            Optional.ofNullable(parameter.getValue())
                .map(val -> parameter.getType().fromString(val))
                .orElse(null)
        ));

        return queryParams;
    }

    protected NamedParameterJdbcTemplate getNamedParameterJdbcTemplate(SqlInput input) {
        return new NamedParameterJdbcTemplate(
                getDataSource(input));
    }

    private HikariConfig getHikariConfig(String url, String userName, String password) {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(url);
        config.setUsername(userName);
        config.setPassword(password);
        //config.setDriverClassName("org.postgresql.Driver");
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
        return config;
    }

    protected DataSource getDataSource(SqlInput input) {
        return dataSources.computeIfAbsent(
                input.getUrl() + input.getLogin(),
            k -> new HikariDataSource(getHikariConfig(
                input.getUrl(),
                input.getLogin(),
                input.getPassword()
            ))
        );
    }

}