package com.pladen.dto;

import com.pladen.entity.DataType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

import java.util.UUID;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Accessors(chain = true)
public class Parameter {
    UUID id;
    String name;
    String value;
    DataType type;
    String title;
    Boolean editable;
    Integer order;
    Boolean editableDictionary;
    UUID dictionaryLinkId;
    String dictionaryNameColumn;
    String dictionaryValueColumn;
}
