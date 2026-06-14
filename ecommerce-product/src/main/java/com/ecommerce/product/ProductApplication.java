package com.ecommerce.product;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

/**
 * 商品服务启动类
 */
@SpringBootApplication
@EnableDiscoveryClient
@MapperScan("com.ecommerce.product.mapper")
public class ProductApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(ProductApplication.class, args);
    }
}
