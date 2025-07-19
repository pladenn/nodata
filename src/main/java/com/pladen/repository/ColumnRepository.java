package com.pladen.repository;

import com.pladen.entity.Column;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ColumnRepository extends JpaRepository<Column, UUID> {
    List<Column> findByActionId(UUID actionId);
}
