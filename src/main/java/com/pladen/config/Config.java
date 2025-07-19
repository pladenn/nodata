package com.pladen.config;

import com.pladen.adapter.DataProvider;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;
import java.util.Map;

import static java.util.function.Function.identity;
import static java.util.stream.Collectors.toMap;

@Configuration
public class Config {

    @Bean
    @Qualifier("dataProviders")
    public Map<String, DataProvider> dataProviders(List<DataProvider> dataProvidersList) {
        return dataProvidersList.stream()
                .collect(toMap(DataProvider::getHandleType, identity()));
    }

}
