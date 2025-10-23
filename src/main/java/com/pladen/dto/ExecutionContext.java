package com.pladen.dto;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

import static com.pladen.service.PropertyService.populateWithProperties;
import static java.util.Collections.unmodifiableList;
import static java.util.Objects.isNull;
import static java.util.Objects.nonNull;
import static java.util.function.Predicate.not;
import static org.apache.commons.lang3.StringUtils.*;

@Accessors(chain = true)
public class ExecutionContext {
    final ObjectMapper objectMapper;
    final ObjectNode variables;
    List<String> columns;

    final Map<String, Parameter> parameters = new HashMap<>();

    @Getter
    @Setter
    String environment;

    @Getter
    @Setter
    UUID actionId;

    private static final String REQUEST_PARAMETERS = "request-parameters";
    private static final String PARAMETERS = "parameters";
    private static final Pattern propertyRegexp = Pattern.compile("\\{(?:[A-Za-z0-9_-]+)(?:\\.[A-Za-z0-9_-]+)*\\}");


    public ExecutionContext(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
        this.variables = objectMapper.createObjectNode();
    }

    public Optional<JsonNode> getData() {
        return Optional.ofNullable(variables.get("DATA"));
    }

    public List<JsonNode> getDataAsList() {
        return nodeToList(getData().orElse(null));
    }

    public List<String> getColumns() {
        return nonNull(columns) ? unmodifiableList(columns) : List.of("body");
    }

    public static List<JsonNode> nodeToList(JsonNode data) {
        return Optional.ofNullable(data)
                .map(node -> node.isArray()
                        ? node.spliterator()
                        : (node.isObject() ? List.of(node).spliterator() : Spliterators.<JsonNode>emptySpliterator())
                )
                .map(spliterator -> StreamSupport.stream(spliterator, false))
                .map(Stream::toList)
                .orElseGet(List::of);
    }

    public List<Parameter> getParameters() {
        return parameters.values()
                .stream()
                .sorted(Comparator.comparingInt(Parameter::getOrder))
                .toList();
    }

    public ExecutionContext putValueByPath(String value, String... parts) {
        final String path = buildPath(parts);
        getParentNode(path).put(getField(path), value);
        return this;
    }

    private void validatePath(String path) {
        if (isBlank(replace(path, "/", EMPTY))) {
            throw new IllegalArgumentException("Path is invalid");
        }

        Stream.of(splitPath(path))
                .filter(StringUtils::isBlank)
                .findAny()
                .ifPresent(part -> {
                    throw new IllegalArgumentException("Path can not contain blank parts");
                });
    }

    private String[] getParentPath(String path) {
        validatePath(path);

        final String[] parts = splitPath(path);

        if (parts.length == 0) {
            return new String[0];
        }

        return Arrays.copyOf(parts, parts.length - 1);
    }

    private String getField(String path) {
        validatePath(path);

        final String[] parts = splitPath(path);

        return parts[parts.length - 1];
    }

    public void putProperties(Map<String, String> values) {
        putProperties(EMPTY, values);
    }

    public void putSystemProperties(Map<String, String> values) {
        putProperties("properties.system", values);
        putProperties("context.system", values);
        putProperties("properties.system", values);
        putProperties("context.system", values);
    }

    public void putEnvironmentProperties(Map<String, String> values) {
        putProperties("properties.env", values);
        putProperties("context.env", values);
        putProperties("properties.environment", values);
        putProperties("context.environment", values);
    }

    public ExecutionContext putRequestParameters(Map<String, String> requestParameters) {
        requestParameters.forEach(this::putRequestParameter);
        return this;
    }

    public ExecutionContext putRequestParameter(String name, String value) {
        if (isBlank(name)) {
            return this;
        }

        return putValueByPath(value, REQUEST_PARAMETERS, name);
    }

    public Optional<String> getRequestParameter(String name) {
        return isBlank(name) ? Optional.empty() : getStringValue(REQUEST_PARAMETERS, name);
    }

    public Optional<String> getSystemProperty(String propertyName) {
        return getStringValue("properties.system", propertyName);
    }

    public Optional<String> getStringValue(String... parts) {
        return getStringValue(variables, parts);
    }

    public static String getNullableStringValue(JsonNode node, String... parts) {
        return getStringValue(node, parts)
                .orElse(null);
    }

    public static Optional<String> getStringValue(JsonNode node, String... parts) {
        return getValue(node, parts)
                .map(val -> val.isTextual() ? val.asText() : val.toString());
    }

    public Optional<JsonNode> getValue(String... parts) {
        return getValue(variables, parts);
    }

    public static Optional<JsonNode> getValue(JsonNode node, String... parts) {
        if (isNull(node)) {
            return Optional.empty();
        }

        return Optional.ofNullable(buildPath(parts))
                .filter(StringUtils::isNoneBlank)
                .map(node::at)
                .filter(not(JsonNode::isNull))
                .filter(not(JsonNode::isMissingNode));
    }

    private static String buildPath(String... parts) {
        return Stream.of(parts)
                .filter(StringUtils::isNoneBlank)
                .map(part -> part.replace(".", "/"))
                .collect(Collectors.joining("/","/", EMPTY));
    }

    public void putProperties(String path, Map<String, String> values) {
        populateWithProperties(values, path)
                .entrySet()
                .stream()
                .filter(pair -> isNotBlank(pair.getKey()))
                .forEach(pair -> putProperty(pair.getValue(),path, pair.getKey()));
    }

    public void putProperty(String value, String... parts) {
        putValueByPath(populatePlaceholders(value), parts);
    }

    public ExecutionContext putValueByPath(JsonNode value, String... parts) {
        final String path = buildPath(parts);
        getParentNode(path).set(getField(path), value);
        return this;
    }

    private String[] splitPath(String path) {
        return (path.trim().startsWith("/") ? path.substring(1) : path)
                .split("/");
    }

    public ExecutionContext putData(Pair<List<String>, JsonNode> data) {
        if (isNull(data)) {
            return this;
        }

        columns = data.getLeft();
        return putValueByPath(data.getRight(), "DATA");
    }

    private ObjectNode getParentNode(String path) {
        ObjectNode tmpNode = variables;

        for (String part : getParentPath(path)) {
            final JsonNode at = tmpNode.at("/" + part);
            if (at == null || !at.isObject()) {
                final ObjectNode newNode = objectMapper.createObjectNode();
                tmpNode.set(part, newNode);
                tmpNode = newNode;
            } else {
                tmpNode = (ObjectNode) at;
            }
        }

        return tmpNode;
    }

    public String populatePlaceholders(String source) {
        return populatePlaceholders(source, variables);
    }

    public void putParameters(List<Parameter> parameters) {
        parameters.forEach(this::putParameter);
    }

    public void putParameter(Parameter parameter) {
        this.parameters.put(parameter.getName(), parameter);
        putValueByPath(parameter.getValue(), PARAMETERS, parameter.getName());
        putValueByPath(parameter.getValue(), parameter.getName());
    }

    private static String populatePlaceholders(String source, ObjectNode variables) {
        if (isBlank(source)) {
            return source;
        }

        String result = source;
        final Matcher m = propertyRegexp.matcher(source);

        while (m.find()) {
            final String path = m.group();

            final String replaced = path.replace("{", "/")
                    .replace("}", EMPTY)
                    .replace(".", "/");

            final JsonNode node = variables.at(replaced);
            if (!node.isMissingNode()) {
                result = replace(result, path, node.asText());
            }
        }

        return result;
    }
}
