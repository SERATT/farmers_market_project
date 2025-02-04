package com.jgroup.farmers_market.mapper;

import com.jgroup.farmers_market.entity.Farmer;
import com.jgroup.farmers_market.entity.User;
import com.jgroup.farmers_market.model.dto.FarmerDto;
import com.jgroup.farmers_market.model.dto.UserDto;

public class UserDtoMapper {
    public static UserDto map(User user) {
        UserDto userDto = new UserDto();
        userDto.setId(user.getId());
        userDto.setUsername(user.getUsername());
        userDto.setIsActive(user.getIsActive());
        userDto.setEmail(user.getEmail());
        return userDto;
    }
}
