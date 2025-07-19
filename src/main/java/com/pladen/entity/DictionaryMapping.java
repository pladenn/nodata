package com.pladen.entity;

import jakarta.persistence.*;
import jakarta.persistence.Column;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.ToString;
import lombok.experimental.FieldDefaults;

import java.util.UUID;

import static jakarta.persistence.FetchType.LAZY;
import static lombok.AccessLevel.PRIVATE;

@Entity
@Data
@FieldDefaults(level = PRIVATE)
public class DictionaryMapping {
    @Id
    @GeneratedValue
    UUID id;

    @Column(name = "dictionary_id")
    UUID dictionaryId;

    @NotNull
    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "action_parameter_id", nullable = false)
    @ToString.Exclude
    Parameter actionParameter;

    @NotNull
    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "dictionary_parameter_id", nullable = false)
    @ToString.Exclude
    Parameter dictionaryParameter;

    String defaultValue;
}