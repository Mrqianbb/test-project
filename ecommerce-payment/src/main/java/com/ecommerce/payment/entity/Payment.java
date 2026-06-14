package com.ecommerce.payment.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ecommerce.common.entity.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 支付实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("payment")
public class Payment extends BaseEntity {
    
    /**
     * 支付ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 支付单号
     */
    private String paymentNo;
    
    /**
     * 订单ID
     */
    private Long orderId;
    
    /**
     * 支付金额
     */
    private BigDecimal amount;
    
    /**
     * 支付状态（0：待支付，1：已支付）
     */
    private Integer status;
    
    /**
     * 支付方式（ALIPAY：支付宝，WECHAT：微信）
     */
    private String paymentMethod;
    
    /**
     * 第三方交易号
     */
    private String transactionId;
}
