package com.pladen.repository;

import com.pladen.entity.Action;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface ActionRepository extends JpaRepository<Action, UUID> {

    Optional<Action> findByCode(String code);

    //todo change exception
    default Action findByCodeOrElseThrow(String code) {
        return findByCode(code).orElseThrow();
    }

    //todo change exception
    default Action findByIdOrElseThrow(UUID id) {
        return findById(id).orElseThrow();
    }

}
