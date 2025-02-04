package com.jgroup.farmers_market.repository;

import com.jgroup.farmers_market.entity.Buyer;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BuyerRepository extends JpaRepository<Buyer, Long> {
}