package com.example.k5_iot_springboot.dto.D_Post.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public record PostResponseDto (
        Long id,
        String title,
        String author
){
    public static PostListResponseDto from(D_Post post){
        
    }
}
