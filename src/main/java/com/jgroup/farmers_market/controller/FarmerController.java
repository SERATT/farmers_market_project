package com.jgroup.farmers_market.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jgroup.farmers_market.entity.Order;
import com.jgroup.farmers_market.entity.Product;
import com.jgroup.farmers_market.entity.ProductImage;
import com.jgroup.farmers_market.entity.User;
import com.jgroup.farmers_market.mapper.ProductDtoMapper;
import com.jgroup.farmers_market.model.dto.OrderDto;
import com.jgroup.farmers_market.model.dto.ProductDto;
import com.jgroup.farmers_market.model.enums.EOrderStatus;
import com.jgroup.farmers_market.repository.OrderRepository;
import com.jgroup.farmers_market.repository.ProductImageRepository;
import com.jgroup.farmers_market.repository.ProductRepository;
import com.jgroup.farmers_market.repository.UserRepository;
import com.jgroup.farmers_market.security.MyUserDetails;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;


@RestController
@RequestMapping("/farmer")
@RequiredArgsConstructor
@Slf4j
@PreAuthorize("hasAuthority('FARMER')")
public class FarmerController {
    private final OrderRepository orderRepository;
    private final ProductImageRepository productImageRepository;
    private final ProductRepository productRepository;
    private final UserRepository userRepository;
    private final ObjectMapper objectMapper;

    private final Path imageStoragePath = Paths.get("product-images");

    @GetMapping("/product")
    @Transactional
    public Page<ProductDto> getProducts(@RequestParam(defaultValue = "0") Integer page, @RequestParam(defaultValue = "20") Integer size) {
        MyUserDetails userPrincipal = (MyUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        User user = userRepository.findByUsername(userPrincipal.getUsername()).get();
        return productRepository.findAllByFarmer_Id(user.getFarmer().getId(), PageRequest.of(page, size))
                .map(ProductDtoMapper::map);
    }

    @GetMapping("/product/{id}")
    @Transactional
    public ResponseEntity<ProductDto> getProduct(@PathVariable Long id) {
        MyUserDetails userPrincipal = (MyUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long farmerId = userRepository.findByUsername(userPrincipal.getUsername()).get().getFarmer().getId();
        Product product = productRepository.findById(id).get();
        if (!Objects.equals(product.getFarmer().getId(), farmerId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        return ResponseEntity.ok(ProductDtoMapper.map(product));
    }

    @PostMapping("/product")
    @Transactional
    public ResponseEntity<ProductDto> addProduct(@RequestBody ProductDto productDto) {
        MyUserDetails userPrincipal = (MyUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        User user = userRepository.findByUsername(userPrincipal.getUsername()).get();
        Product product = new Product();
        product.setName(productDto.getName());
        product.setCategory(productDto.getCategory());
        product.setPrice(productDto.getPrice());
        product.setQuantity(productDto.getQuantity());
        product.setFarmer(user.getFarmer());
        product = productRepository.save(product);
        return ResponseEntity.ok().body(ProductDtoMapper.map(product));
    }

    @PutMapping("/product/{id}")
    @Transactional
    public ResponseEntity<?> updateProduct(@PathVariable Long id, @RequestBody ProductDto productDto) {
        Product product = productRepository.findById(id).get();
        product.setQuantity(productDto.getQuantity());
        product.setName(productDto.getName());
        product.setCategory(productDto.getCategory());
        product.setPrice(productDto.getPrice());
        productRepository.save(product);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/product/{id}")
    @Transactional
    public ResponseEntity<?> deleteProduct(@PathVariable Long id) {
        MyUserDetails userPrincipal = (MyUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long farmerId = userRepository.findByUsername(userPrincipal.getUsername()).get().getFarmer().getId();
        Product product = productRepository.findById(id).get();
        if (!Objects.equals(product.getFarmer().getId(), farmerId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        productRepository.delete(product);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/low-stock")
    @Transactional
    public ResponseEntity<List<ProductDto>> getLowStockProducts() {
        MyUserDetails userPrincipal = (MyUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        User user = userRepository.findByUsername(userPrincipal.getUsername()).get();
        List<ProductDto> lowStockProducts = productRepository.findAllByFarmer_IdAndQuantityLessThan(user.getFarmer().getId(), 10)
                .stream()
                .map(ProductDtoMapper::map)
                .collect(Collectors.toList());

        if (lowStockProducts.isEmpty()) {
            return ResponseEntity.noContent().build();
        }

        return ResponseEntity.ok(lowStockProducts);
    }

    @PostMapping("/product/{id}/images")
    @Transactional
    public ResponseEntity<?> uploadImages(@PathVariable Long id, @RequestParam("files") List<MultipartFile> files) {
        Product product = getProductByIdAndFarmer(id);
        // Ensure storage path exists
        try {
            Files.createDirectories(imageStoragePath);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to create directories for image storage.");
        }

        // Save images and update product
        try {
            productImageRepository.saveAll(files.stream()
                    .map(file -> saveImage(file, id))
                    .filter(Objects::nonNull)
                    .map(ip -> {
                        ProductImage pi = new ProductImage();
                        pi.setImagePath(ip);
                        pi.setProduct(product);
                        return pi;
                    }).collect(Collectors.toSet()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error saving images.");
        }

        return ResponseEntity.ok("Images uploaded successfully");
    }

    private String saveImage(MultipartFile file, Long productId) {
        try {
            // Validate image file
            String fileName = "product_" + productId + "_" + System.currentTimeMillis() + "_" + file.getOriginalFilename();
            Path targetPath = imageStoragePath.resolve(fileName);
            Files.write(targetPath, file.getBytes());
            return targetPath.toString();
        } catch (IOException e) {
            log.error("Failed to save image: " + file.getOriginalFilename(), e);
            return null;
        }
    }

    private Product getProductByIdAndFarmer(Long productId) {
        MyUserDetails userPrincipal = (MyUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long farmerId = userRepository.findByUsername(userPrincipal.getUsername()).get().getFarmer().getId();
        Product product = productRepository.findById(productId).orElseThrow(() -> new RuntimeException("Product not found"));
        if (!Objects.equals(product.getFarmer().getId(), farmerId)) {
            throw new RuntimeException("Unauthorized access to product");
        }
        return product;
    }

    @GetMapping("/orders")
    public ResponseEntity<List<OrderDto>> getOrders() {
        MyUserDetails userPrincipal = (MyUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long farmerId = userRepository.findByUsername(userPrincipal.getUsername()).get().getFarmer().getId();
        return ResponseEntity.ok(
                orderRepository.findAllByProduct_Farmer_Id(farmerId)
                .stream().map(o -> {
                    OrderDto orderDto = new OrderDto();
                    orderDto.setId(o.getId());
                    orderDto.setProductId(o.getProduct().getId());
                    orderDto.setProductName(o.getProduct().getName());
                    orderDto.setOrderedQuantity(o.getQuantity());
                    orderDto.setWarehouseQuantity(o.getProduct().getQuantity());
                    orderDto.setBuyerName(o.getBuyer().getName());
                    orderDto.setBuyerEmail(o.getBuyer().getUser().getEmail());
                    orderDto.setOrderStatus(o.getOrderStatus());
                    orderDto.setTotalPrice(o.getTotalPrice());
                    return orderDto;
                }).collect(Collectors.toList())
        );
    }

    @PutMapping("/orders/{id}")
    public ResponseEntity<?> markOrderAsDone(@PathVariable Long id) {
        Order order = orderRepository.findById(id).get();
        if (order.getQuantity() > order.getProduct().getQuantity()) {
            ResponseEntity.badRequest().body("ordered quantity is more than what is in warehouse");
        }
        order.getProduct().setQuantity(order.getProduct().getQuantity() - order.getQuantity());
        order.setOrderStatus(EOrderStatus.DONE);
        orderRepository.save(order);
        return ResponseEntity.ok("Marked as DONE");
    }

}
