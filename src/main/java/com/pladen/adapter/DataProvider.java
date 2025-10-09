package com.pladen.adapter;

import com.fasterxml.jackson.databind.JsonNode;
import org.apache.commons.lang3.tuple.Pair;

import java.util.List;

public interface DataProvider {
    String getHandleType();

    Pair<List<String>, JsonNode> getData(DataProviderInput input);
}
