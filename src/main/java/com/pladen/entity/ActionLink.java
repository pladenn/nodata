package com.pladen.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Data;
import lombok.ToString;
import lombok.experimental.FieldDefaults;

import java.util.Set;
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

    @OneToMany(fetch = FetchType.LAZY)
    @JoinColumn(name = "link_id", nullable = false)
    @ToString.Exclude
    Set<ActionLinkGroup> actionLinkGroup;

    String category;
    String variable;
    String title;
    boolean viaParameters;
    Integer order;
}
