package com.pladen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Value;
import lombok.extern.jackson.Jacksonized;

import java.util.List;

@Value
@Builder
@AllArgsConstructor
@Jacksonized
public class MenuItem {
    String name;
    String link;
    List<MenuItem> items;
}
