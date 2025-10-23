package com.pladen.adapter.impl.http;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.pladen.adapter.DataProviderInput;
import com.pladen.dto.Parameter;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpHeaders;

import java.util.List;
import java.util.Map;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

import static java.util.Objects.requireNonNullElse;
import static java.util.Spliterator.ORDERED;
import static java.util.Spliterators.spliteratorUnknownSize;
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

        return input.getExecutionContext()
                .getValue("properties.connection.header")
                .filter(JsonNode::isObject)
                .map(ObjectNode.class::cast)
                .map(node -> spliteratorUnknownSize(node.fields(), ORDERED))
                .map(nodes -> StreamSupport.stream(nodes, false))
                .orElseGet(Stream::of)
                .filter(pair -> pair.getValue().isTextual())
                .filter(pair -> isNotBlank(pair.getValue().textValue()))
                .collect(
                        HttpHeaders::new,
                        (headers, pair) -> headers.add(pair.getKey(), pair.getValue().textValue()),
                        HttpHeaders::addAll
                );
    }

}
