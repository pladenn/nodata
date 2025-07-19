package com.pladen.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Data;
import lombok.ToString;
import lombok.experimental.FieldDefaults;

import java.util.UUID;

@Entity
@Data
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Action {
    @Id
    @GeneratedValue
    UUID id;

    @NotNull
    String code;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "connection_id", nullable = false)
    @ToString.Exclude
    Connection connection;

    String query;
    String content;
    String execution_type;
    String title;
    String postProcess;
    String description;
    String redirect;
}
