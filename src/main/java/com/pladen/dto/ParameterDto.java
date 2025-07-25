package com.pladen.dto;

import com.pladen.entity.DataType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

import java.util.List;
import java.util.UUID;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Accessors(chain = true)
public class ParameterDto {
    UUID id;
    String name;
    String value;
    DataType type;
    List<KeyValue> availableValues;
    String title;
    Boolean editable;
    Boolean editableDictionary;
}
