package com.jgroup.farmers_market.repository;

import com.jgroup.farmers_market.entity.Crop;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CropRepository extends JpaRepository<Crop, Long> {
}