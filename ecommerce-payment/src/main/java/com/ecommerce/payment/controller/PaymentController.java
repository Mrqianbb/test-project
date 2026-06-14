package com.ecommerce.payment.controller;

import com.ecommerce.common.result.Result;
import com.ecommerce.payment.entity.Payment;
import com.ecommerce.payment.service.PaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.math.BigDecimal;

/**
 * 支付控制器
 */
@RestController
@RequestMapping("/payments")
@RequiredArgsConstructor
public class PaymentController {
    
    private final PaymentService paymentService;
    
    /**
     * 创建支付
     */
    @PostMapping
    public Result<Payment> createPayment(@Valid @RequestBody Payment payment) {
        Payment createdPayment = paymentService.createPayment(payment);
        return Result.success(createdPayment);
    }
    
    /**
     * 获取支付详情
     */
    @GetMapping("/{id}")
    public Result<Payment> getPaymentById(@PathVariable Long id) {
        Payment payment = paymentService.getById(id);
        return Result.success(payment);
    }
    
    /**
     * 完成支付
     */
    @PostMapping("/{id}/complete")
    public Result<Void> completePayment(@PathVariable Long id) {
        paymentService.completePayment(id);
        return Result.success();
    }
    
    /**
     * 根据订单ID查询支付
     */
    @GetMapping("/order/{orderId}")
    public Result<Payment> getPaymentByOrderId(@PathVariable Long orderId) {
        Payment payment = paymentService.getPaymentByOrderId(orderId);
        return Result.success(payment);
    }
}
