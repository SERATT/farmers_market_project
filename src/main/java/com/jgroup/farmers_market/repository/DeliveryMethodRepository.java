package com.jgroup.farmers_market.repository;

import com.jgroup.farmers_market.entity.DeliveryMethod;
import com.jgroup.farmers_market.model.enums.EDeliveryMethod;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface DeliveryMethodRepository extends JpaRepository<DeliveryMethod, Long> {
    Optional<DeliveryMethod> findDeliveryMethodByName(EDeliveryMethod name);
}
