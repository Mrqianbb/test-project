package com.ecommerce.order.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ecommerce.common.entity.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.util.List;

/**
 * 订单实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("order_info")
public class Order extends BaseEntity {
    
    /**
     * 订单ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 订单号
     */
    private String orderNo;
    
    /**
     * 用户ID
     */
    private Long userId;
    
    /**
     * 订单总金额
     */
    private BigDecimal totalAmount;
    
    /**
     * 订单状态（0：待支付，1：已支付，2：已取消）
     */
    private Integer status;
    
    /**
     * 收货地址
     */
    private String address;
    
    /**
     * 收货人
     */
    private String receiver;
    
    /**
     * 联系电话
     */
    private String phone;
    
    /**
     * 订单明细（非数据库字段）
     */
    @TableField(exist = false)
    private List<OrderItem> items;
}
