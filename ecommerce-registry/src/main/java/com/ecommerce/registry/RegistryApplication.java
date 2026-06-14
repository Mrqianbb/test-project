package com.ecommerce.registry;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 注册中心启动类（Nacos Client，实际使用需启动Nacos Server）
 */
@SpringBootApplication
public class RegistryApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(RegistryApplication.class, args);
    }
}
