package com.pladen.adapter;

import com.pladen.dto.Parameter;
import lombok.Builder;
import lombok.Value;

import java.util.List;
import java.util.Map;

@Value
@Builder
public class DataProviderInput {
    String url;
    String login;
    String password;
    String method;
    String query;
    String content;
    List<Parameter> parameters;
    Map<String, String> properties;
}
