package com.ecommerce.order.feign;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 商品服务Feign客户端
 */
@FeignClient(name = "ecommerce-product")
public interface ProductFeignClient {
    
    /**
     * 更新库存
     */
    @PostMapping("/products/{id}/stock")
    void updateStock(@PathVariable("id") Long id, @RequestParam("quantity") Integer quantity);
}
