package com.pladen.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AccessLevel;
import lombok.Data;
import lombok.ToString;
import lombok.experimental.FieldDefaults;

import java.util.UUID;

@Entity
@Data
@FieldDefaults(level = AccessLevel.PRIVATE)
@Table(name = "\"column\"")
public class Column {
    @Id
    @GeneratedValue
    UUID id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "action_id", nullable = false)
    @ToString.Exclude
    Action action;

    @NotBlank
    @Size(max = 50)
    String name;

    @NotBlank
    String path;

    Integer order;
}
