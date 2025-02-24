package com.jgroup.farmers_market.repository;

import com.jgroup.farmers_market.entity.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long>, JpaSpecificationExecutor<Product> {
    Page<Product> findAllByFarmer_Id(Long farmerId,
                                     Pageable pageable);

    List<Product> findAllByFarmer_IdAndQuantityLessThan(Long farmerId, Integer quantity);

}
