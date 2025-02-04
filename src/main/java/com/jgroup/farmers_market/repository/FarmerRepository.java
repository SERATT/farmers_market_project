package com.jgroup.farmers_market.repository;

import com.jgroup.farmers_market.entity.Farmer;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FarmerRepository extends JpaRepository<Farmer, Long> {
    Page<Farmer> findAllByUser_IsActiveFalse(Pageable pageable);
}