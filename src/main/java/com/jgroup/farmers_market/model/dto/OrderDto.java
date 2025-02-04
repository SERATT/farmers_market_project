package com.jgroup.farmers_market.model.dto;

import com.jgroup.farmers_market.model.enums.EOrderStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OrderDto {
    private Long id;
    private Long productId;
    private String productName;
    private Integer warehouseQuantity;
    private Integer orderedQuantity;
    private String buyerName;
    private String buyerEmail;
    private EOrderStatus orderStatus;
    private Double totalPrice;
}
