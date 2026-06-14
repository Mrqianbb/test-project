package com.ecommerce.batch.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ecommerce.batch.entity.Product;
import org.apache.ibatis.annotations.Mapper;

/**
 * 商品Mapper
 */
@Mapper
public interface ProductMapper extends BaseMapper<Product> {
}
