package com.example.k5_iot_springboot.service;

import com.example.k5_iot_springboot.dto.I_Order.request.StockRequest;
import com.example.k5_iot_springboot.dto.I_Order.response.StockResponse;
import com.example.k5_iot_springboot.dto.ResponseDto;
import com.example.k5_iot_springboot.security.UserPrincipal;
import jakarta.validation.Valid;

public interface I_StockService {
    // @Vaild 유효성을 만족하는지 검증하게 하는 역할
    //    객체(보통 DTO나 Request 객체)가 **유효성 규칙(Validation constraints)**을 만족하는지 검증하도록 스프링에게 알려주는 역할
    //    유효성 검증 실패 시, 스프링은 MethodArgumentNotValidException을 던져서 에러를 처리함

    //@RequestBody로 들어오는 JSON을 DTO로 변환하기 위해서 반드시 있어야한다

    ResponseDto<StockResponse.Response> adjust(UserPrincipal userPrincipal, StockRequest.@Valid StockAdjust req);
    ResponseDto<StockResponse.Response> set(UserPrincipal userPrincipal, StockRequest.StockSet req);
    ResponseDto<StockResponse.Response> get(Long ProductId);
    // 아까 에러 Long 타입 필요하다 했던게 여기서 Long productId 입력이 되었어야한다
}