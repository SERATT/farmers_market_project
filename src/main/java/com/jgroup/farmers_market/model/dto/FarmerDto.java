package com.jgroup.farmers_market.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class FarmerDto {
    private Long userId;
    private Long farmerId;
    private String username;
    private String email;
    private String phoneNumber;
    private Double farmSize;
    private String farmCoordinates;
    private List<CropDto> crops;
}
