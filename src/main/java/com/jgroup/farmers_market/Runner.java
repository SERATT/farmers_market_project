package com.jgroup.farmers_market;

import com.jgroup.farmers_market.entity.Role;
import com.jgroup.farmers_market.model.enums.ERole;
import com.jgroup.farmers_market.repository.RoleRepository;
import com.jgroup.farmers_market.entity.User;
import com.jgroup.farmers_market.repository.UserRepository;
import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
@RequiredArgsConstructor
@Slf4j
public class Runner implements CommandLineRunner {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final RoleRepository roleRepository;
    private final EntityManager em;

    @Transactional
    public void run(String... args) {
        createAdmin();
    }

    private void createAdmin() {
        Optional<User> userOptional = userRepository.findByUsername("teamhadmin");
        if (userOptional.isPresent()) {
            log.info("ADMIN user was set already");
            return;
        }
        log.info("INITIALIZING ADMIN USER CREDENTIALS");
        Role role = roleRepository.findByName(ERole.ADMIN).get();
        User user = new User();
        user.setUsername("teamhadmin");
        user.setEmail("serat5915@gmail.com");
        user.setPassword(passwordEncoder.encode("TryMe"));
        user.setIsActive(true);
        user = userRepository.save(user);
        em.createNativeQuery(
                        String.format("insert into user_roles (user_id, role_id)" +
                                        " values(%d, %d)",
                                user.getId(), role.getId()))
                .executeUpdate();
    }
}
