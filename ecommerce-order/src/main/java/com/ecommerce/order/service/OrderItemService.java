package com.ecommerce.order.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ecommerce.order.entity.OrderItem;
import com.ecommerce.order.mapper.OrderItemMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 订单明细服务
 */
@Service
@RequiredArgsConstructor
public class OrderItemService extends ServiceImpl<OrderItemMapper, OrderItem> {
    
    /**
     * 根据订单ID获取订单明细列表
     */
    public List<OrderItem> getByOrderId(Long orderId) {
        return lambdaQuery().eq(OrderItem::getOrderId, orderId).list();
    }
}
