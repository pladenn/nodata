package com.pladen.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.ToString;
import lombok.experimental.FieldDefaults;

import java.util.List;
import java.util.UUID;

import static jakarta.persistence.FetchType.LAZY;
import static lombok.AccessLevel.PRIVATE;

@Entity
@Data
@FieldDefaults(level = PRIVATE)
public class Dictionary {
    @Id
    @GeneratedValue
    UUID id;

    @NotNull
    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "parameter_id", nullable = false)
    @ToString.Exclude
    Parameter parameter;

    @NotNull
    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "action_id", nullable = false)
    @ToString.Exclude
    Action action;

    @OneToMany
    @ToString.Exclude
    @JoinColumn(name="dictionary_id")
    List<DictionaryMapping> dictionaryMappings;

    String nameColumn;
    String valueColumn;
    Boolean editable;
}