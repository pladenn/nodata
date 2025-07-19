package com.pladen.repository;

import com.pladen.entity.Property;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface PropertyRepository extends JpaRepository<Property, UUID> {

    @Query("select p from Property p where p.propertyCategory.code = :categoryCode and (p.group = :group or :group is null)")
    List<Property> findByPropertyCategoryCodeAndGroup(@Param("categoryCode") String categoryCode, @Param("group") String group);


    Optional<Property> findByPropertyCategoryCodeAndGroupAndProperty(String categoryCode, String group,
                                                                     String property);
}
