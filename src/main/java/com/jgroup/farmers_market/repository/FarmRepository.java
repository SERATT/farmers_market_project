package com.jgroup.farmers_market.repository;

import com.jgroup.farmers_market.entity.Farm;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FarmRepository extends JpaRepository<Farm, Long> {
}