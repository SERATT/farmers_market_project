package com.jgroup.farmers_market.repository;

import com.jgroup.farmers_market.entity.Role;
import com.jgroup.farmers_market.model.enums.ERole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {
    Optional<Role> findByName(ERole eRole);
}