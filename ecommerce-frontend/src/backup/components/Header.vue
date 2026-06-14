<template>
  <el-header class="header">
    <div class="header-content">
      <div class="logo">
        <router-link to="/">
          <el-icon :size="32" color="#409EFF">
            <ShoppingCart />
          </el-icon>
          <span class="logo-text">电商平台</span>
        </router-link>
      </div>

      <div class="nav">
        <router-link to="/" class="nav-item">首页</router-link>
        <router-link to="/products" class="nav-item">商品</router-link>
      </div>

      <div class="actions">
        <router-link to="/cart" class="cart-btn">
          <el-badge :value="cartTotalQuantity" :max="99" type="primary">
            <el-icon :size="24">
              <ShoppingCart />
            </el-icon>
          </el-badge>
          <span class="cart-text">购物车</span>
        </router-link>

        <template v-if="userStore.userInfo">
          <el-dropdown @command="handleCommand">
            <span class="user-info">
              <el-avatar :src="userStore.userInfo.avatar" :size="32">
                {{ userStore.userInfo.nickname?.charAt(0) }}
              </el-avatar>
              <span class="username">{{ userStore.userInfo.nickname }}</span>
              <el-icon>
                <ArrowDown />
              </el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">
                  <el-icon><User /></el-icon>
                  个人中心
                </el-dropdown-item>
                <el-dropdown-item command="orders">
                  <el-icon><Document /></el-icon>
                  我的订单
                </el-dropdown-item>
                <el-dropdown-item divided command="logout">
                  <el-icon><SwitchButton /></el-icon>
                  退出登录
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </template>

        <template v-else>
          <router-link to="/login" class="login-btn">登录</router-link>
          <router-link to="/register" class="register-btn">注册</router-link>
        </template>
      </div>
    </div>
  </el-header>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessageBox } from 'element-plus'
import { useUserStore } from '@/stores/user'
import {
  ShoppingCart,
  ArrowDown,
  User,
  Document,
  SwitchButton
} from '@element-plus/icons-vue'

const router = useRouter()
const userStore = useUserStore()

const cartTotalQuantity = computed(() => userStore.cartTotalQuantity())

const handleCommand = (command) => {
  switch (command) {
    case 'profile':
      router.push('/profile')
      break
    case 'orders':
      router.push('/orders')
      break
    case 'logout':
      ElMessageBox.confirm('确定要退出登录吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        userStore.logout()
        router.push('/')
      })
      break
  }
}
</script>

<style>
.header {
  background: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  height: 60px;
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100%;
  padding: 0 20px;
}

.logo {
  display: flex;
  align-items: center;
  text-decoration: none;
}

.logo-text {
  font-size: 20px;
  font-weight: bold;
  color: #333;
  margin-left: 8px;
}

.nav {
  display: flex;
  gap: 30px;
}

.nav-item {
  color: #666;
  text-decoration: none;
  font-size: 14px;
  transition: color 0.3s;
}

.nav-item:hover {
  color: #409EFF;
}

.actions {
  display: flex;
  align-items: center;
  gap: 20px;
}

.cart-btn {
  display: flex;
  align-items: center;
  gap: 4px;
  color: #666;
  text-decoration: none;
  transition: color 0.3s;
}

.cart-btn:hover {
  color: #409EFF;
}

.cart-text {
  font-size: 14px;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 4px 12px;
  border-radius: 4px;
  transition: background 0.3s;
}

.user-info:hover {
  background: #f5f5f5;
}

.username {
  font-size: 14px;
  color: #333;
}

.login-btn,
.register-btn {
  padding: 6px 20px;
  border-radius: 4px;
  text-decoration: none;
  font-size: 14px;
  transition: all 0.3s;
}

.login-btn {
  color: #409EFF;
}

.login-btn:hover {
  background: rgba(64, 158, 255, 0.1);
}

.register-btn {
  background: #409EFF;
  color: #fff;
}

.register-btn:hover {
  background: #66b1ff;
}
</style>
