package com.ecommerce.user.service;

import cn.hutool.core.util.IdUtil;
import cn.hutool.crypto.digest.BCrypt;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ecommerce.common.exception.BusinessException;
import com.ecommerce.common.result.ResultCode;
import com.ecommerce.user.dto.UserLoginDTO;
import com.ecommerce.user.dto.UserRegisterDTO;
import com.ecommerce.user.entity.User;
import com.ecommerce.user.mapper.UserMapper;
import com.ecommerce.user.vo.UserLoginVO;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.concurrent.TimeUnit;

/**
 * 用户服务
 */
@Service
@RequiredArgsConstructor
public class UserService extends ServiceImpl<UserMapper, User> {
    
    private final StringRedisTemplate redisTemplate;
    
    private static final String TOKEN_PREFIX = "token:";
    private static final long TOKEN_EXPIRE_TIME = 7 * 24 * 60 * 60; // 7天
    
    /**
     * 用户注册
     */
    @Transactional(rollbackFor = Exception.class)
    public void register(UserRegisterDTO dto) {
        // 检查用户名是否已存在
        User existUser = lambdaQuery().eq(User::getUsername, dto.getUsername()).one();
        if (existUser != null) {
            throw new BusinessException(ResultCode.USER_ALREADY_EXIST);
        }
        
        // 创建用户
        User user = new User();
        user.setUsername(dto.getUsername());
        user.setPassword(BCrypt.hashpw(dto.getPassword()));
        user.setNickname(dto.getNickname());
        user.setPhone(dto.getPhone());
        user.setEmail(dto.getEmail());
        user.setStatus(1);
        
        this.save(user);
    }
    
    /**
     * 用户登录
     */
    public UserLoginVO login(UserLoginDTO dto) {
        // 查询用户
        User user = lambdaQuery().eq(User::getUsername, dto.getUsername()).one();
        if (user == null) {
            throw new BusinessException(ResultCode.USER_NOT_EXIST);
        }
        
        // 校验密码
        if (!BCrypt.checkpw(dto.getPassword(), user.getPassword())) {
            throw new BusinessException(ResultCode.PASSWORD_ERROR);
        }
        
        // 校验状态
        if (user.getStatus() != 1) {
            throw new BusinessException(ResultCode.USER_DISABLED);
        }
        
        // 生成Token
        String token = IdUtil.simpleUUID();
        String tokenKey = TOKEN_PREFIX + token;
        
        // 存储用户信息到Redis
        redisTemplate.opsForValue().set(tokenKey, user.getId().toString(), TOKEN_EXPIRE_TIME, TimeUnit.SECONDS);
        
        // 返回登录信息
        UserLoginVO vo = new UserLoginVO();
        vo.setToken(token);
        vo.setUserId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setNickname(user.getNickname());
        vo.setAvatar(user.getAvatar());
        
        return vo;
    }
    
    /**
     * 获取用户ID（根据Token）
     */
    public Long getUserIdByToken(String token) {
        String userId = redisTemplate.opsForValue().get(TOKEN_PREFIX + token);
        if (userId == null) {
            throw new BusinessException(ResultCode.TOKEN_INVALID);
        }
        return Long.parseLong(userId);
    }
    
    /**
     * 登出
     */
    public void logout(String token) {
        redisTemplate.delete(TOKEN_PREFIX + token);
    }
}
