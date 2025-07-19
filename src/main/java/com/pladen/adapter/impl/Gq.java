package com.pladen.adapter.impl;

import com.coxautodev.graphql.tools.GraphQLQueryResolver;
import com.pladen.dto.DataBaseQuery;
import com.pladen.dto.DataBaseQueryResult;
import com.pladen.dto.KeyValue;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class Gq implements GraphQLQueryResolver {
    public DataBaseQueryResult getTtt(DataBaseQuery query) {
        return new DataBaseQueryResult(
                List.of("qw", "rt"),
                List.of(
                        new KeyValue("qw", "qwv"),
                        new KeyValue("rt", "rtv")
                )
        );
    }
}
