package com.pladen.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Data;
import lombok.experimental.FieldDefaults;

import java.util.UUID;

@Entity
@FieldDefaults(level = AccessLevel.PRIVATE)
@Data
public class Connection {
    @Id
    @GeneratedValue
    UUID id;

    String description;

    @NotNull
    String type;
    String url;
    String login;
    String password;
}
