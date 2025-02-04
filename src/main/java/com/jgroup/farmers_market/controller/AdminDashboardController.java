package com.jgroup.farmers_market.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jgroup.farmers_market.entity.User;
import com.jgroup.farmers_market.mapper.BuyerDtoMapper;
import com.jgroup.farmers_market.mapper.FarmerDtoMapper;
import com.jgroup.farmers_market.mapper.UserDtoMapper;
import com.jgroup.farmers_market.model.dto.FarmerDto;
import com.jgroup.farmers_market.model.dto.UserDto;
import com.jgroup.farmers_market.repository.FarmerRepository;
import com.jgroup.farmers_market.repository.UserRepository;
import com.jgroup.farmers_market.service.EmailService;
import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/admin-board")
@Slf4j
@PreAuthorize("hasAuthority('ADMIN')")
public class AdminDashboardController {
    private final FarmerRepository farmerRepository;
    private final UserRepository userRepository;
    private final EmailService emailService;
    private final EntityManager entityManager;

    @GetMapping("/pending-farmer-accounts")
    public ResponseEntity<Page<FarmerDto>> getPendingAccounts(@RequestParam(defaultValue = "0") Integer page, @RequestParam(defaultValue = "20") Integer size) {
        log.info("User roles: " + SecurityContextHolder.getContext().getAuthentication().getAuthorities());
        return ResponseEntity.ok(farmerRepository.findAllByUser_IsActiveFalse(PageRequest.of(page, size))
                .map(FarmerDtoMapper::map));
    }

    @PutMapping("/accept-user")
    public ResponseEntity<String> acceptAccount(@RequestParam Long userId) throws Exception {
        User user = userRepository.findById(userId).orElseThrow(() -> new Exception("userId not found"));
        user.setIsActive(true);
        userRepository.save(user);
        emailService.sendEmail("Account Request Accepted", user.getEmail(), "Dear user of farmers market,\n\nYour account has been activated.\n\nBest,\nJGroup");
        return ResponseEntity.ok("user activated");
    }

    @PutMapping("/disable-user")
    public ResponseEntity<String> disableAccount(@RequestParam Long userId) throws Exception {
        User user = userRepository.findById(userId).orElseThrow(() -> new Exception("userId not found"));
        user.setIsActive(false);
        userRepository.save(user);
        emailService.sendEmail("Account Disabled", user.getEmail(), "Dear user of farmers market,\n\nYour account has been activated.\n\nBest,\nJGroup");
        return ResponseEntity.ok("user activated");
    }

    @DeleteMapping("/reject-user")
    @Transactional
    public ResponseEntity<String> rejectAccount(@RequestParam Long userId) throws Exception {
        User user = userRepository.findById(userId).orElseThrow(() -> new Exception("userId not found"));
        entityManager.createNativeQuery("delete from user_roles where user_id = " + userId).executeUpdate();
        userRepository.delete(user);
        emailService.sendEmail("Account Request Rejected", user.getEmail(), "Dear user of farmers market,\n\nWe are sorry, that we can't accept your application.\n\nBest, JGroup");
        return ResponseEntity.ok("user rejected");
    }

    @GetMapping("/user")
    public ResponseEntity<Page<UserDto>> getUsers(@RequestParam Integer page, @RequestParam Integer size) {
        return ResponseEntity.ok(userRepository.findAllByFarmerIsNotNullOrBuyerIsNotNull(
                        PageRequest.of(page, size))
                .map(UserDtoMapper::map));
    }

    @GetMapping("/user/{id}")
    public ResponseEntity<?> getUser(@PathVariable Long id) {
        User user = userRepository.findById(id).get();
        if (user.getFarmer() != null) {
            return ResponseEntity.ok(FarmerDtoMapper.map(user.getFarmer()));
        } else if (user.getBuyer() != null) {
            return ResponseEntity.ok(BuyerDtoMapper.map(user.getBuyer()));
        }
        return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
    }
}
