package com.pladen.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Data;
import lombok.ToString;
import lombok.experimental.FieldDefaults;

import java.util.UUID;

@Entity
@Data
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ActionLink {
    @Id
    @GeneratedValue
    UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_action_id", nullable = false)
    @ToString.Exclude
    Action parentAction;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "child_action_id", nullable = false)
    @ToString.Exclude
    Action childAction;

    String title;
    boolean isActionTarget;
    boolean viaParameters;
    Integer order;
}
