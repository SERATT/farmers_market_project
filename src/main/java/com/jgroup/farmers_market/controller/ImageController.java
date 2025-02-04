package com.jgroup.farmers_market.controller;

import com.jgroup.farmers_market.entity.ProductImage;
import com.jgroup.farmers_market.repository.ProductImageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/images")
@RequiredArgsConstructor
public class ImageController {
    private final ProductImageRepository productImageRepository;

    @GetMapping(value = "/{id}", produces = {MediaType.IMAGE_PNG_VALUE, MediaType.IMAGE_JPEG_VALUE})
    public ResponseEntity<Resource> getImage(@PathVariable Long id) throws IOException {
        ProductImage pi = productImageRepository.findById(id).get();
        final ByteArrayResource inputStream = new ByteArrayResource(Files.readAllBytes(Paths.get(
                pi.getImagePath()
        )));
        return ResponseEntity
                .status(HttpStatus.OK)
                .contentLength(inputStream.contentLength())
                .body(inputStream);
    }
}
