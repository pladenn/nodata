package com.pladen.adapter.impl.http;

import static com.pladen.service.PropertyService.populateWithProperties;
import static java.util.Objects.isNull;
import static java.util.Objects.nonNull;
import static java.util.stream.Collectors.toMap;

import com.fasterxml.jackson.databind.JsonNode;
import com.pladen.adapter.DataProvider;
import com.pladen.adapter.DataProviderInput;
import com.pladen.dto.Parameter;
import com.pladen.service.CommonHelper;
import java.net.URI;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.tuple.Pair;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;
import org.springframework.web.util.UriBuilder;

@Component
public class HttpDataProvider implements DataProvider {
    private static final String CODE = "code";
    private static final String BODY = "body";
    private static final String CONTENT = "content";

    private final CommonHelper commonHelper;

    public HttpDataProvider(CommonHelper commonHelper) {
        this.commonHelper = commonHelper;
    }

    @Override
    public String getHandleType() {
        return "HTTP";
    }

    @Override
    @Transactional
    public Pair<List<String>, JsonNode> getData(DataProviderInput input, boolean loggingEnabled) {
        final HttpInput httpInput = new HttpInput(input);

        final String url = input.getExecutionContext().populatePlaceholders(httpInput.getUrl());
        final RestClient.RequestBodySpec request = RestClient.create(URI.create(url).toString())
                .method(HttpMethod.valueOf(httpInput.getMethod()))
                .uri(uriBuilder -> buildUri(uriBuilder, httpInput))
                .headers(httpHeaders -> httpHeaders.addAll(httpInput.getHeaders()))
                .headers(httpHeaders -> httpHeaders.putIfAbsent(HttpHeaders.CONTENT_TYPE,
                        List.of(MediaType.APPLICATION_JSON.toString())));

        if (nonNull(httpInput.getContent())) {
            request.body(prepareBody(httpInput));
        }

        final ResponseEntity<String> response = request.retrieve().toEntity(String.class);
        final String responseBody = response.getBody();
        final MediaType contentType = response.getHeaders().getContentType();

        // Not every downstream service returns JSON (e.g. an XML API) -- unconditionally calling
        // objectMapper.readTree(responseBody) threw an uncaught JsonProcessingException for those,
        // surfacing as a raw 500 with no nodata error envelope. Trust the declared Content-Type
        // first, then confirm with an actual parse attempt, and fall back to the raw body under
        // "content" instead of failing when the response genuinely isn't JSON.
        final boolean declaredJson = isNull(contentType) || contentType.isCompatibleWith(MediaType.APPLICATION_JSON);
        if (declaredJson && commonHelper.isParsableJson(responseBody)) {
            return Pair.of(List.of(BODY), commonHelper.createJsonNode(responseBody));
        }
        return Pair.of(List.of(CONTENT), commonHelper.createObjectNode().put(CONTENT, responseBody));
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

        // Collectors.toMap throws NPE on a null VALUE, and getParameters() returns every parameter
        // declared on the action -- including any that arrived without a value and have no
        // default_value. Skipping those leaves their placeholder unsubstituted in the body, which is
        // both harmless and debuggable; the NPE was neither, because it surfaced as an opaque 500
        // (getData is @Transactional, so the real exception is swallowed by the caller's catch and
        // the commit throws instead).
        final Map<String, String> parameters = new HashMap<>();
        httpInput.getParameters()
                .stream()
                .filter(parameter -> nonNull(parameter.getValue()))
                .forEach(parameter ->
                        parameters.put("{" + parameter.getName() + "}", parameter.getValue()));

        //todo get from execution context
        return populateWithProperties(httpInput.getContent(), parameters);
    }

}
