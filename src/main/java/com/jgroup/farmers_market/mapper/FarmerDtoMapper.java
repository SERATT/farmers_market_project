package com.jgroup.farmers_market.mapper;

import com.jgroup.farmers_market.entity.Farmer;
import com.jgroup.farmers_market.model.dto.CropDto;
import com.jgroup.farmers_market.model.dto.FarmerDto;

import java.util.stream.Collectors;

public class FarmerDtoMapper {
    public static FarmerDto map(Farmer farmer) {
        FarmerDto farmerDto = new FarmerDto();
        farmerDto.setUserId(farmer.getUser().getId());
        farmerDto.setFarmerId(farmer.getId());
        farmerDto.setUsername(farmer.getUser().getUsername());
        farmerDto.setEmail(farmer.getUser().getEmail());
        farmerDto.setPhoneNumber(farmer.getPhoneNumber());
        farmerDto.setFarmSize(farmer.getFarm().getSize());
        farmerDto.setFarmCoordinates(farmer.getFarm().getLat() + " " + farmer.getFarm().getLon());
        farmerDto.setCrops(
                farmer.getFarm().getCrops().stream()
                        .map(c -> new CropDto(c.getName(), c.getAmount()))
                        .collect(Collectors.toList())
        );
        return farmerDto;
    }
}
