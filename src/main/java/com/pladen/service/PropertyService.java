package com.pladen.service;

import com.pladen.entity.Property;
import com.pladen.repository.ParameterRepository;
import com.pladen.repository.PropertyRepository;
import com.pladen.service.configuration.NodataConfiguration;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.apache.commons.collections4.MapUtils;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Stream;

import static java.util.Objects.*;
import static java.util.stream.Collectors.toMap;
import static org.apache.commons.lang3.StringUtils.*;
import static org.springframework.util.CollectionUtils.isEmpty;

@Service
@RequiredArgsConstructor
public class PropertyService {
    private final PropertyRepository propertyRepository;
    private final NodataConfiguration nodataConfiguration;
    private final Environment environment;

    private static final String SYSTEM_PROPERTY_PREFIX = "system";
    private static final String CONTEXT_PROPERTY_PREFIX = "context";

    private Map<String, String> getEnvironmentProperties() {
        final Map<String, String> properties = requireNonNullElseGet(nodataConfiguration.getSystem(), Map::<String, String>of)
                .entrySet()
                .stream()
                .collect(toMap(
                        k -> "{" + CONTEXT_PROPERTY_PREFIX + "." + SYSTEM_PROPERTY_PREFIX + "." + k.getKey() + "}",
                        v -> requireNonNullElse(environment.getProperty(v.getValue()), v.getValue())
                ));

        return populateWithProperties(properties);
    }

    public Optional<String> getSystemProperty(String property) {
        if (isNull(property)) {
            return Optional.empty();
        }

        return propertyRepository.findByPropertyCategoryCodeAndGroupAndProperty(CONTEXT_PROPERTY_PREFIX,
                SYSTEM_PROPERTY_PREFIX, property)
                .map(Property::getValue);
    }

    @Transactional
    public Map<String, String> getEnvironmentProperties(@NonNull String context) {
        if (isBlank(context)) {
            return Map.of();
        }

        final Map<String, String> systemProperties = getSystemProperties();

        if (SYSTEM_PROPERTY_PREFIX.equals(context)) {
            return systemProperties;
        }

        return mergeProperties(
                systemProperties,
                getProperties(CONTEXT_PROPERTY_PREFIX, context, "env", systemProperties)
        );
    }

    public Map<String, String> mergeProperties(Map<String, String>... properties) {
        return Stream.of(properties)
                .filter(Objects::nonNull)
                .map(Map::entrySet)
                .flatMap(Collection::stream)
                .collect(toMap(Map.Entry::getKey, Map.Entry::getValue, (a, b) -> b));
    }

    private Map<String, String> populateWithProperties(Map<String, String> properties) {
        return populateWithProperties(properties, properties);
    }

    private Map<String, String> populateWithProperties(Map<String, String> parameters, Map<String, String> values) {

        if (isEmpty(parameters) || isEmpty(values)) {
            return parameters;
        }

        final String[] keyArr = parameters.keySet().toArray(String[]::new);
        final String[] valueArr = parameters.values().toArray(String[]::new);

        return parameters.entrySet()
                .stream()
                .collect(toMap(
                        Map.Entry::getKey,
                        v -> populateWithProperties(v.getValue(), keyArr, valueArr)
                ));
    }

    public String populateWithProperties(String source, String[] keys, String[] values) {
        return replaceEach(source, keys, values);
    }

    public String populateWithProperties(String source, Map<String, String> values) {
        if (isBlank(source) || MapUtils.isEmpty(values)) {
            return source;
        }

        final List<String> keyArr = new ArrayList<>();
        final List<String> valueArr = new ArrayList<>();

        values.forEach((key, value) -> {
            keyArr.add("{" + key + "}");
            valueArr.add(value);
        });

        return replaceEach(source, keyArr.toArray(new String[0]), valueArr.toArray(new String[0]));
    }

    private Map<String, String> getSystemProperties() {
        final Map<String, String> environmentProperties = getEnvironmentProperties();
        return mergeProperties(
                environmentProperties,
                getProperties(CONTEXT_PROPERTY_PREFIX, SYSTEM_PROPERTY_PREFIX, null, environmentProperties)
        );
    }

    private Map<String, String> getProperties(String categoryCode, String originalGroup, String groupName, Map<String, String> properties) {
        return propertyRepository.findByPropertyCategoryCodeAndGroup(categoryCode, originalGroup)
                .stream()
                .collect(toMap(
                        k -> "{" + k.getPropertyCategory().getName() + "." +
                                requireNonNullElseGet(groupName, k::getGroup) + "." +
                                k.getProperty() + "}",
                        v -> populateWithProperties(v.getValue(), properties)
                ));
    }


    public Map<String, String> getAdditionalPropertiesForObject(UUID objectId) {
        if (isNull(objectId)) {
            return Map.of();
        }

        return getAdditionalPropertiesForObject(objectId, getSystemProperties());
    }

    public Map<String, String> getAdditionalPropertiesForObject(UUID objectId, Map<String, String> properties) {
        if (isNull(objectId)) {
            return Map.of();
        }

        return getProperties(objectId.toString(), null, null, properties);
    }
}
