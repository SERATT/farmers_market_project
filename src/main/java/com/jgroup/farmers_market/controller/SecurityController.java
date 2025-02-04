package com.jgroup.farmers_market.controller;

import com.jgroup.farmers_market.entity.User;
import com.jgroup.farmers_market.model.api.*;
import com.jgroup.farmers_market.model.enums.ERole;
import com.jgroup.farmers_market.repository.RoleRepository;
import com.jgroup.farmers_market.repository.UserRepository;
import com.jgroup.farmers_market.security.JwtUtils;
import com.jgroup.farmers_market.security.MyUserDetails;
import com.jgroup.farmers_market.service.BuyerService;
import com.jgroup.farmers_market.service.EmailService;
import com.jgroup.farmers_market.service.FarmerService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class SecurityController {
    private final AuthenticationManager authenticationManager;
    private final JwtUtils jwtUtils;
    private final UserRepository userRepository;
    private final EmailService emailService;
    private final PasswordEncoder passwordEncoder;
    private final RoleRepository roleRepository;
    private final FarmerService farmerService;
    private final EntityManager em;
    private final BuyerService buyerService;

    @PostMapping("/farmer/signup")
    @Operation(summary = "signing up process for farmers")
    @Transactional
    public ResponseEntity<String> signUp(@RequestBody FarmerSignupRequest farmerSignupRequest) {
        User user = new User();
        user.setUsername(farmerSignupRequest.getUsername());
        user.setPassword(passwordEncoder.encode(farmerSignupRequest.getPassword()));
        user.setEmail(farmerSignupRequest.getEmail());
        user.setIsActive(false);
        user.setFarmer(farmerService.createFarmer(user, farmerSignupRequest));
        user = userRepository.save(user);
        em.createNativeQuery(String.format(
                "INSERT INTO user_roles(user_id, role_id) values (%d, %d)",
                user.getId(), roleRepository.findByName(ERole.FARMER).get().getId()
        )).executeUpdate();
        return ResponseEntity.ok("Your request is pending");
    }


    @PostMapping("/buyer/signup")
    @Operation(summary = "signing up process for buyers")
    @Transactional
    public ResponseEntity<String> singUp(@RequestBody BuyerSignupRequest buyerSignupRequest) {
        User user = new User();
        user.setUsername(buyerSignupRequest.getUsername());
        user.setPassword(passwordEncoder.encode(buyerSignupRequest.getPassword()));
        user.setEmail(buyerSignupRequest.getEmail());
        user.setIsActive(true);
        user.setBuyer(buyerService.createBuyer(user, buyerSignupRequest));
        user = userRepository.save(user);
        em.createNativeQuery(String.format(
                "INSERT INTO user_roles(user_id, role_id) values (%d, %d)",
                user.getId(), roleRepository.findByName(ERole.BUYER).get().getId()
        )).executeUpdate();
        return ResponseEntity.ok("REGISTERED");
    }

    @PostMapping("/signin")
    @Operation(summary = "signin for all (admin farmer buyer")
    @Transactional
    public ResponseEntity<JwtResponse> signin(@RequestBody AuthRequest authRequest) {
        Authentication authentication = authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(authRequest.getUsername(), authRequest.getPassword()));
        SecurityContextHolder.getContext().setAuthentication(authentication);
        String accessToken = jwtUtils.generateAccessToken(authentication);
        MyUserDetails userPrincipal = (MyUserDetails) authentication.getPrincipal();
        List<String> roles = userPrincipal.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toList());
        return ResponseEntity.ok(new JwtResponse(accessToken, userPrincipal.getUsername(), roles));
    }


    @GetMapping("/admin/send-reset-password-email")
    @Transactional
    public ResponseEntity<String> sendResetPasswordEmail(@RequestParam String email) throws Exception {
        User user = userRepository.findByEmail(email).orElseThrow(() -> new Exception("email not found"));
        if (!user.getRoles().contains(roleRepository.findByName(ERole.ADMIN).get())) {
            throw new Exception("not an admin");
        }
        String token = UUID.randomUUID().toString();
        user.setPasswordResetToken(token);
        user.setPasswordResetTokenExpiresAt(LocalDateTime.now().plusMinutes(10L));
        user = userRepository.save(user);
        emailService.sendEmail("Farmer's Market Password Reset Token", user.getEmail(), "DO NOT SHARE: " +  token);
        return ResponseEntity.ok("Reset Token was sent to your email");
    }

    @PostMapping("/admin/reset-password")
    @Transactional
    public ResponseEntity<String> resetPassword(@RequestBody PasswordResetRequest passwordResetRequest) throws Exception {
        User user = userRepository.findByUsername(passwordResetRequest.getUsername()).orElseThrow(() -> new Exception("username not found"));
        if (!Objects.equals(passwordResetRequest.getToken(), user.getPasswordResetToken())) {
            return ResponseEntity.ok("Wrong Token");
        }
        if (user.getPasswordResetToken() == null) {
            return ResponseEntity.ok("reset token not generated");
        }
        if (user.getPasswordResetTokenExpiresAt().isBefore(LocalDateTime.now())) {
            return ResponseEntity.ok("expired");
        }
        user.setPassword(passwordEncoder.encode(passwordResetRequest.getNewPassword()));
        return ResponseEntity.ok("password was reset");
    }

}
