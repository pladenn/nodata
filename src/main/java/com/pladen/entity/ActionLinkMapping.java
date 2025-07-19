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
public class ActionLinkMapping {
    @Id
    @GeneratedValue
    UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "action_link_id", nullable = false)
    @ToString.Exclude
    ActionLink actionLink;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parameter_id", nullable = false)
    @ToString.Exclude
    Parameter parameter;

    String mapping;
    String defaultValue;
}
