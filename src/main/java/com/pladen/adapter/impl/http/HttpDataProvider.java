package com.pladen.adapter.impl.http;

import com.fasterxml.jackson.databind.JsonNode;
import com.pladen.adapter.DataProvider;
import com.pladen.adapter.DataProviderInput;
import com.pladen.dto.Parameter;
import com.pladen.service.CommonHelper;
import com.pladen.service.PropertyService;
import org.apache.commons.lang3.tuple.Pair;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;
import org.springframework.web.util.UriBuilder;

import java.net.URI;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static com.pladen.service.PropertyService.populateWithProperties;
import static java.util.Objects.*;
import static java.util.stream.Collectors.toMap;
import static org.apache.commons.lang3.StringUtils.EMPTY;

@Component
public class HttpDataProvider implements DataProvider {
    private static final String CODE = "code";
    private static final String BODY = "body";

    //todo remove
    private final PropertyService propertyService;
    private final CommonHelper commonHelper;

    public HttpDataProvider(PropertyService propertyService, CommonHelper commonHelper) {
        this.propertyService = propertyService;
        this.commonHelper = commonHelper;
    }

    @Override
    public String getHandleType() {
        return "HTTP";
    }

    @Override
    @Transactional
    public Pair<List<String>, JsonNode> getData(DataProviderInput input) {
        final HttpInput httpInput = new HttpInput(input);

        final RestClient.RequestBodySpec request = RestClient.create(URI.create(httpInput.getUrl()).toString())
                .method(HttpMethod.valueOf(httpInput.getMethod()))
                .uri(uriBuilder -> buildUri(uriBuilder, httpInput))
                .headers(httpHeaders -> httpHeaders.addAll(httpInput.getHeaders()));

        if (nonNull(httpInput.getContent())) {
            request.body(prepareBody(httpInput));
        }

        final String responseBody = request.retrieve()
                .body(String.class);

        return  Pair.of(List.of("body"), commonHelper.createJsonNode(responseBody));
    }

    private URI buildUri(UriBuilder uriBuilder, HttpInput httpInput) {
        final Map<String, String> variables = httpInput.getParameters()
                .stream()
                .filter(pair -> httpInput.getQuery().contains(pair.getName()))
                .collect(toMap(Parameter::getName, Parameter::getValue));

        return uriBuilder.path(httpInput.getQuery())
                .build(variables);
    }

    private String prepareBody(HttpInput httpInput) {
        if (isNull(httpInput.getContent())) {
            return null;
        }

        final Map<String, String> parameters = httpInput.getParameters()
                .stream()
                .collect(toMap(
                        k -> "{" + k.getName() + "}",
                        Parameter::getValue
                ));

        //todo get from execution context
        return populateWithProperties(httpInput.getContent(), parameters);
    }

    //todo remove
    private Pair<List<String>, List<Map<String, String>>> transformResponse(String body) {
        return transformResponse(null, body);
    }

    private Pair<List<String>, List<Map<String, String>>> transformResponse(Integer statusCode, String body) {
        final String code = Optional.ofNullable(statusCode)
            .map(Object::toString)
            .orElse(EMPTY);

        return commonHelper.oneRowData(
            Map.of(CODE, code,
                BODY, requireNonNullElse(body, EMPTY))
        );
    }

}
