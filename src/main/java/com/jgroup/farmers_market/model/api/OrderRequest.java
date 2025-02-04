package com.jgroup.farmers_market.model.api;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class OrderRequest {
    private Long productId;
    private Integer quantity;
    private Double totalPrice;
}
