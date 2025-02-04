package com.jgroup.farmers_market.controller;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jgroup.farmers_market.entity.Buyer;
import com.jgroup.farmers_market.entity.Order;
import com.jgroup.farmers_market.entity.Product;
import com.jgroup.farmers_market.mapper.ProductDtoMapper;
import com.jgroup.farmers_market.model.api.OrderRequest;
import com.jgroup.farmers_market.model.dto.ProductDto;
import com.jgroup.farmers_market.model.enums.EOrderStatus;
import com.jgroup.farmers_market.repository.OrderRepository;
import com.jgroup.farmers_market.repository.ProductRepository;
import com.jgroup.farmers_market.repository.UserRepository;
import com.jgroup.farmers_market.security.MyUserDetails;
import com.jgroup.farmers_market.service.ProductService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/buyer")
@RequiredArgsConstructor
@PreAuthorize("hasAnyAuthority('ADMIN', 'BUYER')")
public class BuyerController {
    private final ProductRepository productRepository;
    private final ObjectMapper objectMapper;
    private final ProductService productService;
    private final UserRepository userRepository;
    private final OrderRepository orderRepository;

    @GetMapping("/product")
    public ResponseEntity<Page<ProductDto>> getProducts(@RequestParam Integer page, @RequestParam Integer size) {
        return ResponseEntity.ok(
                productRepository.findAll(PageRequest.of(page, size))
                        .map(ProductDtoMapper::map)
        );
    }

    @GetMapping("/search")
    public ResponseEntity<Page<ProductDto>> searchProducts(
            @RequestParam String name,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice,
            @RequestParam(defaultValue = "price") String sortField,
            @RequestParam(defaultValue = "ASC") String sortDirection,
            Pageable pageable) {

        Page<ProductDto> products = productService.searchProducts(
                name, category, minPrice, maxPrice, sortField, sortDirection, pageable);

        return ResponseEntity.ok(products);
    }

    @PostMapping("/order")
    @Transactional
    public ResponseEntity<String> orderProduct(@RequestBody OrderRequest orderRequest) throws Exception {
        if (orderRequest.getProductId() == null || orderRequest.getQuantity() == null || orderRequest.getTotalPrice() == null) {
            throw new Exception("validation fail");
        }
        MyUserDetails myUserDetails = (MyUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Buyer buyer = userRepository.findByUsername(myUserDetails.getUsername()).get().getBuyer();
        Order order = new Order();
        order.setBuyer(buyer);
        order.setQuantity(orderRequest.getQuantity());
        order.setProduct(productRepository.findById(orderRequest.getProductId()).get());
        order.setOrderStatus(EOrderStatus.PROCESSING);
        order.setTotalPrice(orderRequest.getTotalPrice());
        orderRepository.save(order);
        return ResponseEntity.ok("Order placed");
    }

}
