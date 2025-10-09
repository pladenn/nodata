package com.pladen.service;

import com.pladen.entity.Property;
import com.pladen.repository.PropertyRepository;
import com.pladen.service.configuration.NodataConfiguration;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.apache.commons.collections4.MapUtils;
import org.apache.commons.lang3.tuple.Pair;
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

    private static final String SYSTEM_PROPERTY_PREFIX = "system";
    private static final String CONTEXT_PROPERTY_PREFIX = "context";

    public Map<String, String> getApplicationProperties() {
        return requireNonNullElseGet(nodataConfiguration.getSystem(), Map::of);
    }

    @Transactional
    public Map<String, String> getEnvironmentProperties(@NonNull String environment) {
        return getProperties(environment);
    }

    public static Map<String, String> populateWithProperties(Map<String, String> properties, String... keyPrefixes) {
        return populateWithProperties(properties, properties, keyPrefixes);
    }

    public static Map<String, String> populateWithProperties(Map<String, String> properties, Map<String, String> values, String... keyPrefixes) {

        if (isEmpty(properties) || isEmpty(values)) {
            return properties;
        }

        final Pair<String[], String[]> pair = mapToKeyValuePropertyArrays(values, keyPrefixes);

        return properties.entrySet()
                .stream()
                .collect(toMap(
                        Map.Entry::getKey,
                        v -> populateWithProperties(v.getValue(), pair.getKey(), pair.getValue())
                ));
    }

    public static String populateWithProperties(String source, String[] keys, String[] values) {
        return replaceEach(source, keys, values);
    }

    public static String populateWithProperties(String source, Map<String, String> values) {
        if (isBlank(source) || MapUtils.isEmpty(values)) {
            return source;
        }

        final Pair<String[], String[]> pair = mapToKeyValuePropertyArrays(values);

        return replaceEach(source, pair.getKey(), pair.getValue());
    }

    private static Pair<String[], String[]> mapToKeyValuePropertyArrays(Map<String, String> properties) {
        return mapToKeyValuePropertyArrays(properties, EMPTY);
    }

    private static Pair<String[], String[]> mapToKeyValuePropertyArrays(Map<String, String> properties, String... keyPrefixes) {
        final List<String> keyArr = new ArrayList<>();
        final List<String> valueArr = new ArrayList<>();

        properties.forEach((key, value) -> Stream.of(keyPrefixes)
                .distinct()
                .map(prefix -> isNoneBlank(prefix) ? prefix + "." : EMPTY)
                .forEach(prefix -> {
                    keyArr.add("{" + prefix + key + "}");
                    valueArr.add(value);
                }));

        return Pair.of(keyArr.toArray(new String[0]), valueArr.toArray(new String[0]));
    }

    public Map<String, String> getSystemProperties() {
        return getProperties(SYSTEM_PROPERTY_PREFIX);
    }

    private Map<String, String> getProperties(String group) {
        return isBlank(group) ? Map.of() : getPropertiesByCategoryAndGroup(CONTEXT_PROPERTY_PREFIX, group);
    }

    private Map<String, String> getPropertiesByCategory(String category) {
        return getPropertiesByCategoryAndGroup(category, null);
    }

    @Transactional
    public Map<String, String> getAdditionalPropertiesForObject(UUID objectId) {
        return Optional.ofNullable(objectId)
                .map(UUID::toString)
                .map(this::getPropertiesByCategory)
                .orElseGet(Map::of);
    }

    private Map<String, String> getPropertiesByCategoryAndGroup(String category, String group) {
        if (isBlank(category)) {
            return Map.of();
        }

        return propertyRepository.findByPropertyCategoryCodeAndGroup(category, group)
                .stream()
                .collect(toMap(
                        Property::getProperty,
                        Property::getValue)
                );
    }

}
