package com.jgroup.farmers_market.repository;

import com.jgroup.farmers_market.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findAllByProduct_Farmer_Id(Long product_farmer_id);
}