package com.pladen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;

import java.util.List;

@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DataBaseQueryResult {
    List<String> columns;
    List<KeyValue> data;
}
