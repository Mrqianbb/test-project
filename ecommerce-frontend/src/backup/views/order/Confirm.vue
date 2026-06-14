<template>
  <div class="order-confirm-page">
    <Header />

    <main class="main-content">
      <div class="page-container">
        <h2 class="page-title">确认订单</h2>

        <el-form
          ref="orderFormRef"
          :model="orderForm"
          :rules="orderRules"
          label-width="100px"
        >
          <!-- 收货信息 -->
          <div class="section">
            <h3 class="section-title">收货信息</h3>

            <el-form-item label="收货人" prop="receiver">
              <el-input v-model="orderForm.receiver" placeholder="请输入收货人姓名" />
            </el-form-item>

            <el-form-item label="联系电话" prop="phone">
              <el-input
                v-model="orderForm.phone"
                placeholder="请输入联系电话"
                maxlength="11"
              />
            </el-form-item>

            <el-form-item label="收货地址" prop="address">
              <el-input
                v-model="orderForm.address"
                type="textarea"
                :rows="3"
                placeholder="请输入详细收货地址"
              />
            </el-form-item>
          </div>

          <!-- 商品信息 -->
          <div class="section">
            <h3 class="section-title">商品清单</h3>

            <div class="order-items">
              <div
                v-for="item in userStore.cart"
                :key="item.id"
                class="order-item"
              >
                <el-image
                  :src="item.imageUrl"
                  fit="cover"
                  class="item-image"
                />

                <div class="item-info">
                  <h4 class="item-name">{{ item.name }}</h4>
                  <p class="item-spec">数量：{{ item.quantity }}</p>
                </div>

                <div class="item-price">
                  ¥{{ formatPrice(item.price * item.quantity) }}
                </div>
              </div>
            </div>
          </div>

          <!-- 订单金额 -->
          <div class="section">
            <h3 class="section-title">订单金额</h3>

            <div class="amount-summary">
              <div class="amount-item">
                <span class="label">商品总额：</span>
                <span class="value">¥{{ formatPrice(cartTotalAmount) }}</span>
              </div>
              <div class="amount-item">
                <span class="label">运费：</span>
                <span class="value">¥0.00</span>
              </div>
              <div class="amount-item total">
                <span class="label">应付总额：</span>
                <span class="value">¥{{ formatPrice(cartTotalAmount) }}</span>
              </div>
            </div>
          </div>

          <!-- 支付方式 -->
          <div class="section">
            <h3 class="section-title">支付方式</h3>

            <el-radio-group v-model="orderForm.paymentMethod">
              <el-radio label="ALIPAY">
                <el-icon><Wallet /></el-icon>
                支付宝
              </el-radio>
              <el-radio label="WECHAT">
                <el-icon><Wallet /></el-icon>
                微信支付
              </el-radio>
            </el-radio-group>
          </div>

          <!-- 提交按钮 -->
          <div class="actions">
            <el-button size="large" @click="goBack">
              返回购物车
            </el-button>
            <el-button
              type="primary"
              size="large"
              :loading="orderStore.loading"
              @click="handleSubmit"
            >
              提交订单
            </el-button>
          </div>
        </el-form>
      </div>
    </main>

    <Footer />
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { useOrderStore } from '@/stores/order'
import { getPaymentMethodText } from '@/utils/validate'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'
import { Wallet } from '@element-plus/icons-vue'

const router = useRouter()
const userStore = useUserStore()
const orderStore = useOrderStore()

const orderFormRef = ref(null)

const orderForm = reactive({
  receiver: '',
  phone: '',
  address: '',
  paymentMethod: 'ALIPAY'
})

const orderRules = {
  receiver: [
    { required: true, message: '请输入收货人姓名', trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '请输入联系电话', trigger: 'blur' },
    {
      pattern: /^1[3-9]\d{9}$/,
      message: '请输入正确的手机号',
      trigger: 'blur'
    }
  ],
  address: [
    { required: true, message: '请输入收货地址', trigger: 'blur' },
    { min: 5, message: '收货地址至少5个字符', trigger: 'blur' }
  ]
}

const cartTotalAmount = computed(() => {
  return userStore.cartTotalAmount()
})

const formatPrice = (price) => {
  return parseFloat(price).toFixed(2)
}

const goBack = () => {
  router.back()
}

const handleSubmit = async () => {
  const valid = await orderFormRef.value.validate()
  if (!valid) return

  if (userStore.cart.length === 0) {
    ElMessage.warning('购物车为空')
    router.push('/cart')
    return
  }

  // 构建订单数据
  const orderData = {
    userId: userStore.userInfo.userId,
    address: orderForm.address,
    receiver: orderForm.receiver,
    phone: orderForm.phone,
    items: userStore.cart.map(item => ({
      productId: item.id,
      productName: item.name,
      price: item.price,
      quantity: item.quantity,
      totalAmount: item.price * item.quantity
    }))
  }

  const order = await orderStore.createOrder(orderData)

  if (order) {
    // 清空购物车
    userStore.clearCart()

    // 跳转到支付页面
    router.push(`/payment/${order.id}`)
  }
}
</script>

<style>
.order-confirm-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.main-content {
  flex: 1;
  padding-top: 60px;
}

.page-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.page-title {
  font-size: 28px;
  color: #333;
  margin-bottom: 30px;
}

.section {
  background: #fff;
  border-radius: 8px;
  padding: 24px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.section-title {
  font-size: 18px;
  color: #333;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 2px solid #f0f0f0;
}

.order-items {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.order-item {
  display: flex;
  align-items: center;
  padding: 12px;
  background: #f9f9f9;
  border-radius: 4px;
}

.item-image {
  width: 60px;
  height: 60px;
  border-radius: 4px;
  margin-right: 12px;
}

.item-info {
  flex: 1;
}

.item-name {
  font-size: 14px;
  color: #333;
  margin-bottom: 4px;
}

.item-spec {
  font-size: 12px;
  color: #999;
  margin: 0;
}

.item-price {
  font-size: 18px;
  color: #F56C6C;
  font-weight: bold;
}

.amount-summary {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.amount-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 14px;
}

.amount-item .label {
  color: #666;
}

.amount-item .value {
  color: #333;
  font-weight: 500;
}

.amount-item.total {
  padding-top: 12px;
  border-top: 2px solid #f0f0f0;
  font-size: 18px;
}

.amount-item.total .value {
  color: #F56C6C;
  font-weight: bold;
  font-size: 24px;
}

.actions {
  display: flex;
  justify-content: flex-end;
  gap: 16px;
  margin-top: 20px;
}
</style>
