package com.ecommerce.product.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ecommerce.common.exception.BusinessException;
import com.ecommerce.common.result.ResultCode;
import com.ecommerce.product.entity.Product;
import com.ecommerce.product.mapper.ProductMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * 商品服务
 */
@Service
@RequiredArgsConstructor
public class ProductService extends ServiceImpl<ProductMapper, Product> {
    
    private final RedisTemplate<String, Product> redisTemplate;
    
    private static final String PRODUCT_CACHE_PREFIX = "product:";
    private static final long CACHE_EXPIRE_TIME = 30 * 60; // 30分钟
    
    /**
     * 创建商品
     */
    @Transactional(rollbackFor = Exception.class)
    public void createProduct(Product product) {
        this.save(product);
        cacheProduct(product);
    }
    
    /**
     * 获取商品详情
     */
    public Product getProductById(Long id) {
        // 先查缓存
        String cacheKey = PRODUCT_CACHE_PREFIX + id;
        Product product = redisTemplate.opsForValue().get(cacheKey);
        
        if (product == null) {
            // 缓存未命中，查询数据库
            product = this.getById(id);
            if (product == null) {
                throw new BusinessException(ResultCode.PRODUCT_NOT_EXIST);
            }
            // 写入缓存
            cacheProduct(product);
        }
        
        return product;
    }
    
    /**
     * 获取商品列表
     */
    public List<Product> getProductList(Long categoryId) {
        if (categoryId == null) {
            return lambdaQuery().eq(Product::getStatus, 1).list();
        }
        return lambdaQuery()
                .eq(Product::getStatus, 1)
                .eq(Product::getCategoryId, categoryId)
                .list();
    }
    
    /**
     * 更新商品
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateProduct(Product product) {
        this.updateById(product);
        // 清除缓存
        redisTemplate.delete(PRODUCT_CACHE_PREFIX + product.getId());
    }
    
    /**
     * 更新库存
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateStock(Long id, Integer quantity) {
        // 检查库存是否足够
        Product product = this.getById(id);
        if (product == null) {
            throw new BusinessException(ResultCode.PRODUCT_NOT_EXIST);
        }
        if (product.getStock() < quantity) {
            throw new BusinessException(ResultCode.STOCK_INSUFFICIENT);
        }
        
        // 扣减库存
        boolean success = lambdaUpdate()
                .eq(Product::getId, id)
                .ge(Product::getStock, quantity)
                .setSql("stock = stock - " + quantity)
                .update();
        
        if (!success) {
            throw new BusinessException(ResultCode.STOCK_INSUFFICIENT);
        }
        
        // 清除缓存
        redisTemplate.delete(PRODUCT_CACHE_PREFIX + id);
    }
    
    /**
     * 缓存商品
     */
    private void cacheProduct(Product product) {
        String cacheKey = PRODUCT_CACHE_PREFIX + product.getId();
        redisTemplate.opsForValue().set(cacheKey, product, CACHE_EXPIRE_TIME, TimeUnit.SECONDS);
    }
}
