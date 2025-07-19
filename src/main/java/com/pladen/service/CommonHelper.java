package com.pladen.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.pladen.dto.MenuItem;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import lombok.experimental.FieldDefaults;
import org.apache.commons.lang3.tuple.Pair;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static com.pladen.dto.Column.MESSAGE;
import static lombok.AccessLevel.PRIVATE;

@Component
@RequiredArgsConstructor
@FieldDefaults(makeFinal = true, level = PRIVATE)
public class CommonHelper {
    ObjectMapper objectMapper;

    @SneakyThrows
    public String objectToJson(Object object) {
        return objectMapper.writeValueAsString(object);
    }

    @SneakyThrows
    public <T> T jsonToObject(String json, TypeReference<T> typeReference) {
        return objectMapper.readValue(json, typeReference);
    }

    public Pair<List<String>, List<Map<String, String>>> message(@NonNull String message) {
        return oneRowData(Map.of(MESSAGE, message));
    }

    public Pair<List<String>, List<Map<String, String>>> oneRowData(@NonNull Map<String, String> data) {
        return Pair.of(new ArrayList<>(data.keySet()), List.of(data));
    }



}