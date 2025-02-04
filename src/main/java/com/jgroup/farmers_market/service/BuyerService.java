package com.jgroup.farmers_market.service;

import com.jgroup.farmers_market.entity.Buyer;
import com.jgroup.farmers_market.entity.User;
import com.jgroup.farmers_market.model.api.BuyerSignupRequest;
import com.jgroup.farmers_market.repository.DeliveryMethodRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class BuyerService {

    private final DeliveryMethodRepository deliveryMethodRepository;

    @Transactional
    public Buyer createBuyer(User user, BuyerSignupRequest buyerSignupRequest) {
        Buyer buyer = new Buyer();
        buyer.setUser(user);
        buyer.setName(buyerSignupRequest.getName());
        buyer.setDeliveryMethods(buyerSignupRequest.getPreferredDeliveryMethods()
                .stream()
                .map(dm -> deliveryMethodRepository.findDeliveryMethodByName(dm).get())
                .collect(Collectors.toSet())
        );
        return buyer;
    }
}
