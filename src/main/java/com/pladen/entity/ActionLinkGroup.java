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
public class ActionLinkGroup {
    @Id
    @GeneratedValue
    UUID id;

/*    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "link_id", nullable = false)
    @ToString.Exclude
    ActionLink actionLink;*/

    String group;
    Integer order;
    String variable;

}
