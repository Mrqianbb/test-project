package com.ecommerce.payment.feign;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

/**
 * 订单服务Feign客户端
 */
@FeignClient(name = "ecommerce-order")
public interface OrderFeignClient {
    
    /**
     * 更新订单状态
     */
    @PostMapping("/orders/{id}/status")
    void updateOrderStatus(@PathVariable("id") Long id, Integer status);
}
