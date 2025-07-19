package com.pladen.repository;

import com.pladen.entity.ActionLink;
import com.pladen.entity.ActionLinkMapping;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ActionLinkMappingRepository extends JpaRepository<ActionLinkMapping, UUID> {
    List<ActionLinkMapping> findByActionLinkId(UUID actionLinkId);
}
