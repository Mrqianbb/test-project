package com.ecommerce.order.controller;

import com.ecommerce.common.result.Result;
import com.ecommerce.order.entity.Order;
import com.ecommerce.order.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/**
 * 订单控制器
 */
@RestController
@RequestMapping("/orders")
@RequiredArgsConstructor
public class OrderController {
    
    private final OrderService orderService;
    
    /**
     * 创建订单
     */
    @PostMapping
    public Result<Order> createOrder(@Valid @RequestBody Order order) {
        Order createdOrder = orderService.createOrder(order);
        return Result.success(createdOrder);
    }
    
    /**
     * 获取订单详情
     */
    @GetMapping("/{id}")
    public Result<Order> getOrderById(@PathVariable Long id) {
        Order order = orderService.getOrderById(id);
        return Result.success(order);
    }
    
    /**
     * 获取用户订单列表
     */
    @GetMapping("/user/{userId}")
    public Result<List<Order>> getUserOrders(@PathVariable Long userId) {
        List<Order> orders = orderService.getUserOrders(userId);
        return Result.success(orders);
    }
    
    /**
     * 取消订单
     */
    @PostMapping("/{id}/cancel")
    public Result<Void> cancelOrder(@PathVariable Long id) {
        orderService.cancelOrder(id);
        return Result.success();
    }
    
    /**
     * 更新订单状态
     */
    @PostMapping("/{id}/status")
    public Result<Void> updateOrderStatus(@PathVariable Long id, @RequestParam Integer status) {
        orderService.updateOrderStatus(id, status);
        return Result.success();
    }
}
