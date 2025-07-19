package com.pladen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.Value;

import java.util.List;
import java.util.UUID;

//@Value
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DataBaseQuery {
    String query;
    //UUID connectionId;
    String environment;
    //List<DataBaseQueryParameter> parameters;
}
