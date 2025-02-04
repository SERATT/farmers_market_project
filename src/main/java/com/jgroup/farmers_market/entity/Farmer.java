package com.jgroup.farmers_market.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.CascadeType;

import java.util.Set;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Table(name = "farmer")
public class Farmer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(optional = false)
    @JoinColumn(name = "user_id")
    private User user;

    @OneToOne(optional = false, mappedBy = "farmer")
    @Cascade({CascadeType.PERSIST, CascadeType.DELETE_ORPHAN})
    private Farm farm;

    @Column(name = "phone_number")
    private String phoneNumber;

    @OneToMany(mappedBy = "farmer")
    @Cascade({CascadeType.PERSIST, CascadeType.DELETE_ORPHAN})
    private Set<Product> products;
}
