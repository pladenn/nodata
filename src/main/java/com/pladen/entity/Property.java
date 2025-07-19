package com.pladen.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Data;
import lombok.experimental.FieldDefaults;

import java.util.UUID;

@Entity
@Data
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Property {

    @Id
    @GeneratedValue
    UUID id;

    @ManyToOne
    @JoinColumn(name="category_id", nullable=false)
    PropertyCategory propertyCategory;

    String group;

    @NotEmpty
    String property;

    @NotNull
    String value;
}
