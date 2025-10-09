package com.pladen.repository;

import com.pladen.entity.ActionLink;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ActionLinkRepository extends JpaRepository<ActionLink, UUID> {

    @Query("""
        select al from ActionLink al
        where (al.parentAction.id = :parentActionId or al.parentAction.id is null)
        and (al.category in :categories)
        order by al.parentAction.id, al.category, al.order
    """)
    List<ActionLink> findByParentActionIdAndCategoryIn(@Param("parentActionId")  UUID parentActionId,
                                                       @Param("categories") List<String> categories);
    List<ActionLink> findByParentActionIdAndCategory(UUID parentActionId, String category);

}
