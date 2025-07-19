package com.pladen.dto;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public enum Tab {
    DATA("data"),
    PARAMETERS("parameters");

    public final String value;
}
