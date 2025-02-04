package com.jgroup.farmers_market.model.api;

import com.jgroup.farmers_market.model.enums.EDeliveryMethod;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Set;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class BuyerSignupRequest {
    private String username;
    private String email;
    private String password;
    private String name;
    private Set<EDeliveryMethod> preferredDeliveryMethods;
}
