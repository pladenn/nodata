package com.pladen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Value;

import java.util.List;
import java.util.Map;

@Value
@Builder
@AllArgsConstructor
public class Data {
    String title;
    String description;
    String menu;
    List<MenuItem> menuItems;
    List<Parameter> parameters;
    Map<String, Parameter> actionParameters;
    Map<String, Parameter> systemParameters;
    List<Column> columns;
    List<Map<String, String>> data;
    List<ActionLink> actionLinks;
    Tab tab;
    String postProcess;
    String originalUrl;
    String originalTitle;
    String redirect;
}
