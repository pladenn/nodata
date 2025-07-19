package com.pladen.adapter.impl.http;

import com.pladen.adapter.DataProviderInput;
import com.pladen.dto.Parameter;
import lombok.AllArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpHeaders;

import java.util.List;
import java.util.Map;

import static java.util.Objects.requireNonNullElse;
import static org.apache.commons.lang3.StringUtils.*;

@AllArgsConstructor
public class HttpInput {
    private final DataProviderInput input;

    public String getMethod() {
        return removeStart(input.getMethod(), "HTTP_");
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
        return requireNonNullElse(input.getQuery(), EMPTY);
    }

    public List<Parameter> getParameters() {
        return input.getParameters();
    }

    public Map<String, String> getProperties() {
        return input.getProperties();
    }

    public String getContent() {
        return input.getContent();
    }

    public HttpHeaders getHeaders() {
        return input.getProperties()
                .entrySet()
                .stream()
                .filter(pair -> isHeader(pair.getKey()))
                .collect(
                        HttpHeaders::new,
                        (headers, pair) -> headers.add(extractHeaderName(pair.getKey()), pair.getValue()),
                        HttpHeaders::addAll
                );
    }

    private String extractHeaderName(String propertyName) {
        String headerName = remove(propertyName,"{");
        headerName = remove(headerName,"}");
        headerName = removeStart(headerName,"connection.header.");
        return removeStart(headerName,"action.header.");
    }

    private boolean isHeader(String propertyName) {
        if (StringUtils.isBlank(propertyName)) {
            return false;
        }

        return propertyName.startsWith("{connection.header") ||
                propertyName.startsWith("{action.header");
    }
}
