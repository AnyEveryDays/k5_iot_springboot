package com.example.k5_iot_springboot.service.impl;

import com.example.k5_iot_springboot.dto.I_Order.request.ProductRequest;
import com.example.k5_iot_springboot.dto.I_Order.response.ProductResponse;
import com.example.k5_iot_springboot.dto.ResponseDto;
import com.example.k5_iot_springboot.entity.I_Product;
import com.example.k5_iot_springboot.entity.I_Stock;
import com.example.k5_iot_springboot.repository.I_ProductRepository;
import com.example.k5_iot_springboot.repository.I_StockRepository;
import com.example.k5_iot_springboot.security.UserPrincipal;
import com.example.k5_iot_springboot.service.I_ProductService;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;


@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class I_ProductServiceImpl implements I_ProductService {
    private final I_ProductRepository productRepository;
    private final I_StockRepository stockRepository;

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseDto<ProductResponse.DetailResponse> create(
            UserPrincipal principal,
            ProductRequest.@Valid Create req
        ) {
        ProductResponse.DetailResponse data = null;

        I_Product product = I_Product.builder()
                .name(req.name())
                .price(req.price())
                .build();

        I_Product saved = productRepository.save(product);

        stockRepository.save(
            I_Stock.builder()
                    .product(saved)
                    .build()
        );

        data = new ProductResponse.DetailResponse(saved.getId(), saved.getName(), saved.getPrice());

        return ResponseDto.setSuccess("제품이 성공적으로 등록되었습니다.", data);
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseDto<ProductResponse.DetailResponse> update(
            Long productId, UserPrincipal principal,
            ProductRequest.@Valid Update request) {
        ProductResponse.DetailResponse data = null;

        I_Product product = productRepository.findById(productId)
                .orElseThrow(() -> new EntityNotFoundException("상품을 찾을 수 없습니다"));
        
        if (request.name() == null && request.price() == null){
            throw new IllegalArgumentException("수정할 데이터가 없습니다");
        }
        
        if (request.name() != null) product.setName(request.name());
        if (request.price() != null) product.setPrice(request.price());


        data = new ProductResponse.DetailResponse(
                product.getId(),
                product.getName(),
                product.getPrice());

        return ResponseDto.setSuccess("제품이 성공적으로 수정되었습니다.", data);
    }

    @Override
    // 누구나 할 수 있으니까 권한처리 하지 않음
    public ResponseDto<ProductResponse.DetailResponse> get(Long productId) {
        ProductResponse.DetailResponse data = null;

        I_Product product = productRepository.findById(productId)
                .orElseThrow(() -> new EntityNotFoundException("데이터를 못찾겠어용"));

        data = new ProductResponse.DetailResponse(product.getId(), product.getName(), product.getPrice());


        return ResponseDto.setSuccess("제품이 성공적으로 조회되었습니다.", data);
    }
    @Override
    public ResponseDto<List<ProductResponse.ListResponse>> getAllProducts() {
        List<I_Product> products = productRepository.findAll(); // JPA 레포지토리에서 전체 조회

        List<ProductResponse.ListResponse> data = products.stream()
                .map(product -> new ProductResponse.ListResponse(
                        product.getId(),
                        product.getName(),
                        product.getPrice()
                ))
                .toList();

        return ResponseDto.setSuccess("제품이 성공적으로 조회되었습니다.", data);
    }

}
