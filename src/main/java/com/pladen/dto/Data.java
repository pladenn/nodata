package com.pladen.dto;

import com.fasterxml.jackson.databind.JsonNode;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Value;

import java.util.List;
import java.util.Map;

@Value
@Builder
@AllArgsConstructor
public class Data {
    String description;
    List<MenuItem> menuItems;
    List<ParameterDto> parameters;
    Map<String, ParameterDto> actionParameters;
    Map<String, ParameterDto> systemParameters;
    List<Column> columns;
    JsonNode data;
    List<ActionLink> actionLinks;
    Tab tab;
    String postProcess;
    String originalUrl;
    String originalTitle;
    String redirect;
}
