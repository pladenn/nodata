package com.pladen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Value;

import java.util.List;

@Value
@Builder
@AllArgsConstructor
public class ActionLink {
    String path;
    //Map<String, String> mapping;
    List<ActionLinkMapping> mapping;
    String title;
    boolean isActionTarget;
    boolean viaParameters;
}
