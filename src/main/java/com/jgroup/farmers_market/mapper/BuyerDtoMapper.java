package com.jgroup.farmers_market.mapper;

import com.jgroup.farmers_market.entity.Buyer;
import com.jgroup.farmers_market.entity.DeliveryMethod;
import com.jgroup.farmers_market.model.dto.BuyerDto;
import com.jgroup.farmers_market.model.enums.EDeliveryMethod;

import java.util.Set;
import java.util.stream.Collectors;

public class BuyerDtoMapper {
    public static BuyerDto map(Buyer buyer) {
        BuyerDto buyerDto = new BuyerDto();
        buyerDto.setId(buyer.getId());
        buyerDto.setName(buyer.getName());
        Set<EDeliveryMethod> deliveryMethods = buyer.getDeliveryMethods()
                .stream()
                .map(DeliveryMethod::getName)
                .collect(Collectors.toSet());
        buyerDto.setDeliveryMethodNames(deliveryMethods);
        return buyerDto;
    }
}
