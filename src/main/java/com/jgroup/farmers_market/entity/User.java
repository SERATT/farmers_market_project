package com.jgroup.farmers_market.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.CascadeType;

import java.time.LocalDateTime;
import java.util.LinkedHashSet;
import java.util.Set;

@Entity
@Table(name = "users")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "username")
    private String username;

    @Column(name = "email")
    private String email;

    @Column(name = "password")
    private String password;

    @Column(name = "is_active")
    private Boolean isActive;

    @Column(name = "password_reset_token")
    private String passwordResetToken;

    @Column(name = "password_reset_token_expires_at")
    private LocalDateTime passwordResetTokenExpiresAt;

    @ManyToMany(mappedBy = "users")
    Set<Role> roles = new LinkedHashSet<>();

    @OneToOne(mappedBy = "user")
    @Cascade({CascadeType.PERSIST, CascadeType.DELETE_ORPHAN})
    private Farmer farmer;

    @OneToOne(mappedBy = "user")
    @Cascade({CascadeType.PERSIST, CascadeType.DELETE_ORPHAN})
    private Buyer buyer;
}
