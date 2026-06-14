<template>
  <div class="taobao-cart">
    <Header />

    <div class="main-content">
      <div class="cart-container">
        <div class="cart-header">
          <h2>购物车 <span class="count">({{ cartItems.length }})</span></h2>
          <el-button type="danger" :disabled="cartItems.length === 0" @click="clearCart">
            清空购物车
          </el-button>
        </div>

        <!-- 空购物车 -->
        <el-empty v-if="cartItems.length === 0" description="购物车空空如也">
          <el-button type="primary" @click="goToProducts">去逛逛</el-button>
        </el-empty>

        <!-- 购物车列表 -->
        <div v-else class="cart-content">
          <div class="cart-item" v-for="item in cartItems" :key="item.id">
            <el-checkbox v-model="item.selected" size="large" />

            <!-- 商品图片 -->
            <img :src="item.imageUrl" :alt="item.name" class="item-image" />

            <!-- 商品信息 -->
            <div class="item-info">
              <h3 class="item-name">{{ item.name }}</h3>
              <p class="item-desc">{{ item.description }}</p>
            </div>

            <!-- 价格 -->
            <div class="item-price">
              <span class="price-symbol">¥</span>
              <span class="price-value">{{ item.price }}</span>
            </div>

            <!-- 数量 -->
            <el-input-number
              v-model="item.quantity"
              :min="1"
              :max="item.stock"
              size="small"
              @change="updateTotal"
            />

            <!-- 小计 -->
            <div class="item-subtotal">
              ¥{{ (item.price * item.quantity).toFixed(2) }}
            </div>

            <!-- 删除 -->
            <el-button
              type="danger"
              link
              @click="removeItem(item.id)"
            >
              删除
            </el-button>
          </div>

          <!-- 底部结算栏 -->
          <div class="cart-footer">
            <div class="selected-count">
              已选择 <span class="count">{{ selectedCount }}</span> 件商品
            </div>
            <div class="total-section">
              <div class="total-price">
                <span>合计：</span>
                <span class="price">¥{{ totalAmount }}</span>
              </div>
              <el-button type="danger" size="large" @click="checkout">
                结算 ({{ selectedCount }})
              </el-button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <Footer />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'

const router = useRouter()

const cartItems = ref([])

// 模拟购物车数据
const loadCart = () => {
  cartItems.value = [
    {
      id: 1,
      name: 'iPhone 15 Pro Max',
      description: '苹果 iPhone 15 Pro Max 256GB',
      price: 8999,
      stock: 100,
      imageUrl: 'https://via.placeholder.com/80x80/409eff/ffffff?text=iPhone',
      quantity: 1,
      selected: true
    },
    {
      id: 2,
      name: '华为 Mate 60 Pro',
      description: '华为 Mate 60 Pro 麒麟9000',
      price: 6999,
      stock: 50,
      imageUrl: 'https://via.placeholder.com/80x80/67c23a/ffffff?text=Huawei',
      quantity: 2,
      selected: true
    }
  ]
}

// 选中的商品数量
const selectedCount = computed(() => {
  return cartItems.value.filter(item => item.selected).reduce((sum, item) => sum + item.quantity, 0)
})

// 总金额
const totalAmount = computed(() => {
  return cartItems.value
    .filter(item => item.selected)
    .reduce((sum, item) => sum + item.price * item.quantity, 0)
    .toFixed(2)
})

const updateTotal = () => {
  // 计算总价
}

const removeItem = (id) => {
  const index = cartItems.value.findIndex(item => item.id === id)
  if (index > -1) {
    cartItems.value.splice(index, 1)
    ElMessage.success('已删除')
    
    // 更新localStorage的购物车数量
    const currentCount = parseInt(localStorage.getItem('cartCount') || 0)
    localStorage.setItem('cartCount', Math.max(0, currentCount - 1))
    window.dispatchEvent(new Event('cart-updated'))
  }
}

const clearCart = () => {
  ElMessageBox.confirm('确定要清空购物车吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    cartItems.value = []
    localStorage.setItem('cartCount', 0)
    ElMessage.success('购物车已清空')
    window.dispatchEvent(new Event('cart-updated'))
  })
}

const checkout = () => {
  if (selectedCount.value === 0) {
    ElMessage.warning('请选择要结算的商品')
    return
  }
  
  ElMessage.success('跳转到结算页面')
  // router.push('/order/confirm')
}

const goToProducts = () => {
  router.push('/products')
}

onMounted(() => {
  loadCart()
})
</script>

<style>
.taobao-cart {
  min-height: 100vh;
  background: #f5f7fa;
}

.main-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 76px 20px 40px;
}

.cart-container {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.cart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 20px;
  border-bottom: 1px solid #f0f0f0;
  margin-bottom: 20px;
}

.cart-header h2 {
  margin: 0;
  font-size: 20px;
  color: #333;
}

.cart-header .count {
  color: #ff5000;
  font-weight: normal;
  font-size: 16px;
}

.cart-content {
  min-height: 400px;
}

.cart-item {
  display: grid;
  grid-template-columns: 40px 80px 1fr auto auto auto auto;
  gap: 16px;
  align-items: center;
  padding: 20px 0;
  border-bottom: 1px solid #f0f0f0;
}

.cart-item:last-child {
  border-bottom: none;
}

.item-image {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 4px;
}

.item-info {
  padding-right: 20px;
}

.item-name {
  font-size: 14px;
  color: #333;
  margin: 0 0 8px 0;
}

.item-desc {
  font-size: 12px;
  color: #999;
  margin: 0;
  line-height: 1.6;
}

.item-price {
  text-align: right;
}

.price-symbol {
  font-size: 14px;
  color: #ff5000;
  font-weight: bold;
}

.price-value {
  font-size: 20px;
  color: #ff5000;
  font-weight: bold;
  margin-left: 2px;
}

.item-subtotal {
  font-size: 16px;
  color: #ff5000;
  font-weight: bold;
}

.cart-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 20px;
  border-top: 2px solid #ff5000;
  margin-top: 20px;
}

.selected-count {
  font-size: 14px;
  color: #666;
}

.selected-count .count {
  color: #ff5000;
  font-weight: bold;
  font-size: 18px;
}

.total-section {
  display: flex;
  align-items: center;
  gap: 20px;
}

.total-price {
  font-size: 16px;
  color: #333;
}

.total-price .price {
  font-size: 24px;
  color: #ff5000;
  font-weight: bold;
  margin-left: 8px;
}

@media (max-width: 768px) {
  .cart-item {
    grid-template-columns: 1fr;
    gap: 12px;
  }

  .item-image {
    width: 100%;
    height: auto;
  }

  .cart-footer {
    flex-direction: column;
    align-items: stretch;
  }
}
</style>
