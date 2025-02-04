package com.jgroup.farmers_market.entity;

import com.jgroup.farmers_market.model.enums.EDeliveryMethod;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "delivery_method")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class DeliveryMethod {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Enumerated(EnumType.STRING)
    private EDeliveryMethod name;
}
