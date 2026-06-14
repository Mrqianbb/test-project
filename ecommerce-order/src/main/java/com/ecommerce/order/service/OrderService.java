package com.ecommerce.order.service;

import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ecommerce.common.exception.BusinessException;
import com.ecommerce.common.result.ResultCode;
import com.ecommerce.order.entity.Order;
import com.ecommerce.order.entity.OrderItem;
import com.ecommerce.order.feign.ProductFeignClient;
import com.ecommerce.order.mapper.OrderMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

/**
 * 订单服务
 */
@Service
@RequiredArgsConstructor
public class OrderService extends ServiceImpl<OrderMapper, Order> {
    
    private final OrderItemService orderItemService;
    private final ProductFeignClient productFeignClient;
    
    /**
     * 创建订单
     */
    @Transactional(rollbackFor = Exception.class)
    public Order createOrder(Order order) {
        // 生成订单号
        order.setOrderNo(IdUtil.simpleUUID());
        order.setStatus(0);
        
        // 保存订单
        this.save(order);
        
        // 保存订单明细
        List<OrderItem> items = order.getItems();
        if (items != null && !items.isEmpty()) {
            BigDecimal totalAmount = BigDecimal.ZERO;
            
            for (OrderItem item : items) {
                item.setOrderId(order.getId());
                item.setTotalAmount(item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
                totalAmount = totalAmount.add(item.getTotalAmount());
                
                orderItemService.save(item);
                
                // 调用商品服务扣减库存
                productFeignClient.updateStock(item.getProductId(), item.getQuantity());
            }
            
            // 更新订单总金额
            order.setTotalAmount(totalAmount);
            this.updateById(order);
        }
        
        return order;
    }
    
    /**
     * 获取订单详情
     */
    public Order getOrderById(Long id) {
        Order order = this.getById(id);
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_EXIST);
        }
        
        // 查询订单明细
        List<OrderItem> items = orderItemService.getByOrderId(id);
        order.setItems(items);
        
        return order;
    }
    
    /**
     * 获取用户订单列表
     */
    public List<Order> getUserOrders(Long userId) {
        return lambdaQuery().eq(Order::getUserId, userId).list();
    }
    
    /**
     * 取消订单
     */
    @Transactional(rollbackFor = Exception.class)
    public void cancelOrder(Long id) {
        Order order = this.getById(id);
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_EXIST);
        }
        
        // 检查订单状态
        if (order.getStatus() != 0) {
            throw new BusinessException(ResultCode.ORDER_CANNOT_CANCEL);
        }
        
        // 更新订单状态
        order.setStatus(2);
        this.updateById(order);
        
        // 恢复库存
        List<OrderItem> items = orderItemService.getByOrderId(id);
        for (OrderItem item : items) {
            productFeignClient.updateStock(item.getProductId(), -item.getQuantity());
        }
    }
    
    /**
     * 更新订单状态
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateOrderStatus(Long id, Integer status) {
        lambdaUpdate()
                .eq(Order::getId, id)
                .set(Order::getStatus, status)
                .update();
    }
}
