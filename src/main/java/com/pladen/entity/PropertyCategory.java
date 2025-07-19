package com.pladen.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import lombok.Data;
import lombok.experimental.FieldDefaults;

import java.util.UUID;

import static lombok.AccessLevel.PRIVATE;

@Entity
@Data
@FieldDefaults(level = PRIVATE)
public class PropertyCategory {
    @Id
    @GeneratedValue
    UUID id;

    String code;
    String name;
}
