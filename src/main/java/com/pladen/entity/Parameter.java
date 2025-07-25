package com.pladen.entity;

import jakarta.persistence.*;
import jakarta.persistence.Column;
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
public class Parameter {
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

    @NotNull
    @Enumerated(EnumType.STRING)
    DataType type;

    String defaultValue;
    Integer order;
    Boolean editable;
    String title;
    @Column(name = "dictionary_id")
    UUID dictionaryLinkId;
    String nameColumn;
    String valueColumn;
    Boolean editableDictionary;
}
