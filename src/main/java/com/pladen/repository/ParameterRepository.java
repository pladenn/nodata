package com.pladen.repository;

import com.pladen.entity.Parameter;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ParameterRepository extends JpaRepository<Parameter, UUID> {
    List<Parameter> findByActionId(UUID actionId);

}
