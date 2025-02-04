package com.jgroup.farmers_market.repository;

import com.jgroup.farmers_market.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);

    Optional<User> findByUsername(String username);

    Page<User> findAllByFarmerIsNotNullOrBuyerIsNotNull(Pageable pageable);
}
