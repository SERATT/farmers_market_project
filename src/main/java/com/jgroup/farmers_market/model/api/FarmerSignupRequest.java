package com.jgroup.farmers_market.model.api;

import com.jgroup.farmers_market.model.dto.CropDto;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Set;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class FarmerSignupRequest {
    private String username;
    private String email;
    private String password;
    private String phoneNumber;
    private String farmName;
    private Double farmLocationLat;
    private Double farmLocationLon;
    private Double farmSize;
    private Set<CropDto> farmCrops;
}
