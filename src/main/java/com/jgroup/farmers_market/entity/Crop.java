package com.jgroup.farmers_market.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "farm_crop")
public class Crop {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "crop_name")
    private String name;

    @Column(name = "amount")
    private Integer amount;

    @ManyToOne
    @JoinColumn(name = "farm_id")
    private Farm farm;
}