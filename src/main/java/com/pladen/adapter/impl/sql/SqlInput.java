package com.pladen.adapter.impl.sql;

import com.pladen.adapter.DataProviderInput;
import com.pladen.dto.Parameter;
import lombok.AllArgsConstructor;
import lombok.NonNull;

import java.util.List;

@AllArgsConstructor
public class SqlInput {
    @NonNull
    private final DataProviderInput input;

    public String getMethod() {
        return input.getMethod();
    }

    public String getUrl() {
        return input.getUrl();
    }

    public String getLogin() {
        return input.getLogin();
    }

    public String getPassword() {
        return input.getPassword();
    }

    public String getQuery() {
        return input.getQuery();
    }

    public List<Parameter> getParameters() {
        return input.getParameters();
    }
}
