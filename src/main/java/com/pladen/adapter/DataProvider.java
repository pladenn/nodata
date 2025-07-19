package com.pladen.adapter;

import org.apache.commons.lang3.tuple.Pair;

import java.util.List;
import java.util.Map;

public interface DataProvider {
    String getHandleType();

    Pair<List<String>, List<Map<String, String>>> getData(DataProviderInput input);
}
