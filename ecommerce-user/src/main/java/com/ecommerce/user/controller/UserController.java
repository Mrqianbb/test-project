package com.ecommerce.user.controller;

import com.ecommerce.common.result.Result;
import com.ecommerce.user.dto.UserLoginDTO;
import com.ecommerce.user.dto.UserRegisterDTO;
import com.ecommerce.user.entity.User;
import com.ecommerce.user.service.UserService;
import com.ecommerce.user.vo.UserLoginVO;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

/**
 * 用户控制器
 */
@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {
    
    private final UserService userService;
    
    /**
     * 用户注册
     */
    @PostMapping("/register")
    public Result<Void> register(@Valid @RequestBody UserRegisterDTO dto) {
        userService.register(dto);
        return Result.success();
    }
    
    /**
     * 用户登录
     */
    @PostMapping("/login")
    public Result<UserLoginVO> login(@Valid @RequestBody UserLoginDTO dto) {
        UserLoginVO vo = userService.login(dto);
        return Result.success(vo);
    }
    
    /**
     * 获取用户信息
     */
    @GetMapping("/{id}")
    public Result<User> getUserById(@PathVariable Long id) {
        User user = userService.getById(id);
        return Result.success(user);
    }
    
    /**
     * 更新用户信息
     */
    @PutMapping("/{id}")
    public Result<Void> updateUser(@PathVariable Long id, @RequestBody User user) {
        user.setId(id);
        userService.updateById(user);
        return Result.success();
    }
}
