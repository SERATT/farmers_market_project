package com.jgroup.farmers_market.mapper;

import com.jgroup.farmers_market.entity.Product;
import com.jgroup.farmers_market.entity.ProductImage;
import com.jgroup.farmers_market.model.dto.ProductDto;

public class ProductDtoMapper {
    public static ProductDto map(Product product) {
        ProductDto productDto = new ProductDto();
        productDto.setId(product.getId());
        productDto.setName(product.getName());
        productDto.setQuantity(product.getQuantity());
        productDto.setCategory(product.getCategory());
        productDto.setPrice(product.getPrice());
        productDto.setImageIds(
                product.getImages()
                        .stream()
                        .map(ProductImage::getId)
                        .toList());
        return productDto;
    }
}
