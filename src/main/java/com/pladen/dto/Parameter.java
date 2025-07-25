package com.pladen.dto;

import com.pladen.entity.DataType;
import lombok.*;
import lombok.Data;
import lombok.experimental.Accessors;

import java.util.List;
import java.util.UUID;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Accessors(chain = true)
public class Parameter {
    //todo remove unused fields
    UUID id;
    String name;
    String value;
    DataType type;
    List<KeyValue> availableValues;
    String title;
    Boolean editable;
    Boolean editableDictionary;
    com.pladen.entity.Parameter parameter;
}
