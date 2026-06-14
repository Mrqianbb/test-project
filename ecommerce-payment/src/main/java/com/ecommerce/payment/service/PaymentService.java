package com.ecommerce.payment.service;

import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ecommerce.common.exception.BusinessException;
import com.ecommerce.common.result.ResultCode;
import com.ecommerce.payment.entity.Payment;
import com.ecommerce.payment.feign.OrderFeignClient;
import com.ecommerce.payment.mapper.PaymentMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 支付服务
 */
@Service
@RequiredArgsConstructor
public class PaymentService extends ServiceImpl<PaymentMapper, Payment> {
    
    private final OrderFeignClient orderFeignClient;
    
    /**
     * 创建支付
     */
    @Transactional(rollbackFor = Exception.class)
    public Payment createPayment(Payment payment) {
        // 检查订单是否存在
        payment.setPaymentNo(IdUtil.simpleUUID());
        payment.setStatus(0);
        this.save(payment);
        return payment;
    }
    
    /**
     * 完成支付
     */
    @Transactional(rollbackFor = Exception.class)
    public void completePayment(Long id) {
        Payment payment = this.getById(id);
        if (payment == null) {
            throw new BusinessException(ResultCode.PAYMENT_NOT_EXIST);
        }
        
        // 检查支付状态
        if (payment.getStatus() == 1) {
            throw new BusinessException("支付已完成");
        }
        
        // 更新支付状态
        payment.setStatus(1);
        this.updateById(payment);
        
        // 更新订单状态
        orderFeignClient.updateOrderStatus(payment.getOrderId(), 1);
    }
    
    /**
     * 根据订单ID查询支付
     */
    public Payment getPaymentByOrderId(Long orderId) {
        return lambdaQuery().eq(Payment::getOrderId, orderId).one();
    }
}
