package com.pladen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Value;

@Value
@Builder
@AllArgsConstructor
public class ActionLinkMapping {
    String parameterName;
    String path;
    String defaultValue;
}
