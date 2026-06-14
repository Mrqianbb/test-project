package com.ecommerce.product.controller;

import com.ecommerce.common.result.Result;
import com.ecommerce.product.entity.Product;
import com.ecommerce.product.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/**
 * 商品控制器
 */
@RestController
@RequestMapping("/products")
@RequiredArgsConstructor
public class ProductController {
    
    private final ProductService productService;
    
    /**
     * 创建商品
     */
    @PostMapping
    public Result<Void> createProduct(@Valid @RequestBody Product product) {
        productService.createProduct(product);
        return Result.success();
    }
    
    /**
     * 获取商品详情
     */
    @GetMapping("/{id}")
    public Result<Product> getProductById(@PathVariable Long id) {
        Product product = productService.getProductById(id);
        return Result.success(product);
    }
    
    /**
     * 获取商品列表
     */
    @GetMapping("/list")
    public Result<List<Product>> getProductList(@RequestParam(required = false) Long categoryId) {
        List<Product> list = productService.getProductList(categoryId);
        return Result.success(list);
    }
    
    /**
     * 更新商品
     */
    @PutMapping("/{id}")
    public Result<Void> updateProduct(@PathVariable Long id, @RequestBody Product product) {
        product.setId(id);
        productService.updateProduct(product);
        return Result.success();
    }
    
    /**
     * 更新库存
     */
    @PostMapping("/{id}/stock")
    public Result<Void> updateStock(@PathVariable Long id, @RequestParam Integer quantity) {
        productService.updateStock(id, quantity);
        return Result.success();
    }
    
    /**
     * 删除商品
     */
    @DeleteMapping("/{id}")
    public Result<Void> deleteProduct(@PathVariable Long id) {
        productService.removeById(id);
        return Result.success();
    }
}
