package com.jgroup.farmers_market.model.dto;

import com.jgroup.farmers_market.model.enums.EDeliveryMethod;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Set;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class BuyerDto {
    private Long id;
    private String name;
    private Set<EDeliveryMethod> deliveryMethodNames;
}
