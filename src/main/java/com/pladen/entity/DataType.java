package com.pladen.entity;

import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;

import java.time.LocalDate;
import java.util.Optional;
import java.util.function.Function;

@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@RequiredArgsConstructor
public enum DataType {
    UUID(val -> Optional.ofNullable(val)
        .filter(StringUtils::isNoneBlank)
        .filter(v -> !"null".equalsIgnoreCase(v))
        .map(java.util.UUID::fromString)
        .orElse(null), "uuid"),
    STRING(v -> v, "text"),
    TEXT(t -> t, "text"),
    BOOLEAN(BooleanUtils::toBoolean, "boolean"),
    INTEGER(val -> Optional.ofNullable(val)
            .filter(StringUtils::isNoneBlank)
            .filter(v -> !"null".equalsIgnoreCase(v))
            .map(Integer::parseInt)
            .orElse(null), "integer"),
    LONG(val -> Optional.ofNullable(val)
            .filter(StringUtils::isNoneBlank)
            .filter(v -> !"null".equalsIgnoreCase(v))
            .map(Long::parseLong)
            .orElse(null), "bigint"),
    DATE(val -> Optional.ofNullable(val)
            .filter(StringUtils::isNoneBlank)
            .filter(v -> !"null".equalsIgnoreCase(v))
            .map(LocalDate::parse)
            .orElse(null), "date"),
    ;

    DataType(Function<String, Object> fromString, String sqlDataType) {
        this(fromString, Object::toString, sqlDataType);
    }

    Function<String, Object> fromString;
    Function<Object, String> toString;
    @Getter
    String sqlDataType;

    public Object fromString(@NotNull String value) {
        return fromString.apply(value);
    }

    public String toString(@NotNull Object value) {
        return toString.apply(value);
    }
}
