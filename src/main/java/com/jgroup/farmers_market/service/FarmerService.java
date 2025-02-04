package com.jgroup.farmers_market.service;

import com.jgroup.farmers_market.entity.Crop;
import com.jgroup.farmers_market.entity.Farm;
import com.jgroup.farmers_market.entity.Farmer;
import com.jgroup.farmers_market.entity.User;
import com.jgroup.farmers_market.model.api.FarmerSignupRequest;
import com.jgroup.farmers_market.model.dto.CropDto;
import com.jgroup.farmers_market.repository.CropRepository;
import com.jgroup.farmers_market.repository.FarmRepository;
import com.jgroup.farmers_market.repository.FarmerRepository;
import com.jgroup.farmers_market.repository.UserRepository;
import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FarmerService {
    private final EntityManager em;
    private final UserRepository userRepository;
    private final FarmerRepository farmerRepository;
    private final CropRepository cropRepository;
    private final FarmRepository farmRepository;

    @Transactional
    public void deleteFarmer(User user) {
        if (user.getFarmer() != null && user.getFarmer().getFarm() != null && user.getFarmer().getFarm().getCrops() != null) {
            cropRepository.deleteAllInBatch(user.getFarmer().getFarm().getCrops());
        }
        if (user.getFarmer() != null && user.getFarmer().getFarm() != null) {
            farmRepository.delete(user.getFarmer().getFarm());
        }
        if (user.getFarmer() != null) {
            farmerRepository.delete(user.getFarmer());
        }
        userRepository.delete(user);
    }

    @Transactional
    public Farmer createFarmer(User user, FarmerSignupRequest farmerSignupRequest) {
        Farmer farmer = new Farmer();
        farmer.setUser(user);
        farmer.setPhoneNumber(farmerSignupRequest.getPhoneNumber());
        Farm farm = new Farm();
        farm.setFarmer(farmer);
        farm.setSize(farmerSignupRequest.getFarmSize());
        farm.setLat(farmerSignupRequest.getFarmLocationLat());
        farm.setLon(farmerSignupRequest.getFarmLocationLon());
        farm.setCrops(createCropsFromDtos(farm, farmerSignupRequest.getFarmCrops()));
        farmer.setFarm(farm);
        return farmer;
    }

    private Set<Crop> createCropsFromDtos(Farm farm, Set<CropDto> farmCrops) {
        return farmCrops.stream()
                .map((dto) -> {
                    Crop crop = new Crop();
                    crop.setFarm(farm);
                    crop.setName(dto.getCropName());
                    crop.setAmount(dto.getAmount());
                    return crop;
                })
                .collect(Collectors.toSet());
    }
}
