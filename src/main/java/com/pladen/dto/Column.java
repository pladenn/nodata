package com.pladen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Value;

@Value
@Builder
@AllArgsConstructor
public class Column {
    public static final String MESSAGE = "message";
    public static final Column MESSAGE_COLUMN = new Column(MESSAGE);

    String path;
    String name;

    public Column(String path) {
        this(path, path);
    }
}
