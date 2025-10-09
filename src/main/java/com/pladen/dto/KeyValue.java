package com.pladen.dto;

import lombok.Builder;
import lombok.Value;

import static org.apache.commons.lang3.StringUtils.defaultIfBlank;

@Builder
@Value
public final class KeyValue {
    String key;
    String value;

    public KeyValue(String key, String value) {
        this.key = defaultIfBlank(key, value);
        this.value = value;
    }
}
