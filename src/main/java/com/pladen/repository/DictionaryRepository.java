package com.pladen.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.pladen.entity.Dictionary;

@Repository
public interface DictionaryRepository extends JpaRepository<Dictionary, UUID> {
    Optional<Dictionary> findByParameterId(UUID parameterId);
}
