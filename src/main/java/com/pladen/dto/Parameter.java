package com.pladen.dto;

import com.pladen.entity.DataType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Value;

import java.util.List;
import java.util.UUID;

@Value
@Builder
@AllArgsConstructor
public class Parameter {
    UUID id;
    String name;
    String value;
    DataType type;
    List<KeyValue> availableValues;
    String defaultValue;
    String title;
    Boolean editable;
}
