package com.pladen.entity;

import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;

import java.util.Optional;
import java.util.function.Function;

@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@RequiredArgsConstructor
public enum DataType {
    UUID(val -> Optional.ofNullable(val)
        .filter(StringUtils::isNoneBlank)
        .filter(v -> !"null".equalsIgnoreCase(v))
        .map(java.util.UUID::fromString)
        .orElse(null)),
    STRING(v -> v),
    TEXT(t -> t),
    BOOLEAN(BooleanUtils::toBoolean),
    INTEGER(val -> Optional.ofNullable(val)
            .filter(StringUtils::isNoneBlank)
            .filter(v -> !"null".equalsIgnoreCase(v))
            .map(Integer::parseInt)
            .orElse(null)),
    ;

    DataType(Function<String, Object> fromString) {

        this(fromString, Object::toString);
    }

    Function<String, Object> fromString;
    Function<Object, String> toString;

    public Object fromString(@NotNull String value) {

        return fromString.apply(value);
    }

    public String toString(@NotNull Object value) {
        return toString.apply(value);
    }
}
