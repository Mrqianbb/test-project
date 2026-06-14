package com.ecommerce.common.result;

/**
 * 响应状态码枚举
 */
public enum ResultCode {
    
    SUCCESS(200, "操作成功"),
    ERROR(500, "操作失败"),
    
    // 用户相关
    USER_NOT_EXIST(1001, "用户不存在"),
    USER_ALREADY_EXIST(1002, "用户已存在"),
    PASSWORD_ERROR(1003, "密码错误"),
    USER_DISABLED(1004, "用户已被禁用"),
    TOKEN_INVALID(1005, "Token无效"),
    TOKEN_EXPIRED(1006, "Token已过期"),
    
    // 商品相关
    PRODUCT_NOT_EXIST(2001, "商品不存在"),
    STOCK_INSUFFICIENT(2002, "库存不足"),
    PRODUCT_OFF_SHELF(2003, "商品已下架"),
    
    // 订单相关
    ORDER_NOT_EXIST(3001, "订单不存在"),
    ORDER_STATUS_ERROR(3002, "订单状态错误"),
    ORDER_CANNOT_CANCEL(3003, "订单不能取消"),
    
    // 支付相关
    PAYMENT_FAILED(4001, "支付失败"),
    PAYMENT_NOT_EXIST(4002, "支付记录不存在"),
    PAYMENT_AMOUNT_ERROR(4003, "支付金额错误"),
    
    // 参数校验
    PARAM_ERROR(5001, "参数错误"),
    PARAM_MISSING(5002, "参数缺失");
    
    private final Integer code;
    private final String message;
    
    ResultCode(Integer code, String message) {
        this.code = code;
        this.message = message;
    }
    
    public Integer getCode() {
        return code;
    }
    
    public String getMessage() {
        return message;
    }
}
