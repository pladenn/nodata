package com.pladen.repository;

import com.pladen.entity.Connection;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface ConnectionRepository extends JpaRepository<Connection, UUID> {
}
