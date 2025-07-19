package com.pladen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.Value;
import lombok.extern.jackson.Jacksonized;

@Builder
@AllArgsConstructor
@Value
public class KeyValue {
    String key;
    String value;
}
