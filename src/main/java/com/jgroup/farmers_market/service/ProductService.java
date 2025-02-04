package com.jgroup.farmers_market.service;

import com.jgroup.farmers_market.entity.Product;
import com.jgroup.farmers_market.mapper.ProductDtoMapper;
import com.jgroup.farmers_market.model.dto.ProductDto;
import com.jgroup.farmers_market.repository.ProductRepository;
import com.jgroup.farmers_market.specification.ProductSpecification;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ProductService {
    private final ProductRepository productRepository;

    public Page<ProductDto> searchProducts(String name, String category,
                                           Double minPrice, Double maxPrice, String sortField,
                                           String sortDirection, Pageable pageable) {
        Specification<Product> spec = Specification.where(ProductSpecification.hasName(name));
        if (category != null && !category.isBlank()) {
            spec.and(ProductSpecification.hasCategory(category));
        }
        if (minPrice != null && maxPrice != null) {
            spec.and(ProductSpecification.hasPriceBetween(minPrice, maxPrice));
        }

        Sort sort = Sort.by(Sort.Direction.fromString(sortDirection), sortField);
        return productRepository.findAll(spec, PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(), sort))
                .map(ProductDtoMapper::map);
    }
}
