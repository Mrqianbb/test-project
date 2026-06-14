<template>
  <div class="payment-page">
    <Header />

    <main class="main-content">
      <div class="page-container">
        <el-card>
          <template #header>
            <div class="card-header">
              <h2>收银台</h2>
              <span class="order-no">订单号：{{ orderNo }}</span>
            </div>
          </template>

          <div class="payment-content">
            <!-- 订单信息 -->
            <div class="order-info">
              <div class="info-item">
                <span class="label">订单金额：</span>
                <span class="value">¥{{ formatPrice(amount) }}</span>
              </div>

              <div class="info-item">
                <span class="label">支付方式：</span>
                <span class="value">{{ getPaymentMethodText(paymentMethod) }}</span>
              </div>
            </div>

            <!-- 二维码支付 -->
            <div class="qrcode-section">
              <div class="qrcode-container">
                <div class="qrcode-placeholder">
                  <el-icon :size="80" color="#409EFF">
                    <Wallet />
                  </el-icon>
                  <p>请使用{{ getPaymentMethodText(paymentMethod) }}扫码支付</p>
                </div>
              </div>

              <div class="payment-tips">
                <h4>支付提示</h4>
                <ul>
                  <li>请使用{{ getPaymentMethodText(paymentMethod) }}扫码支付</li>
                  <li>支付完成后页面将自动跳转</li>
                  <li>如长时间未跳转，请点击"完成支付"按钮</li>
                </ul>
              </div>
            </div>

            <!-- 操作按钮 -->
            <div class="payment-actions">
              <el-button size="large" @click="handleCancel">
                取消支付
              </el-button>
              <el-button
                type="primary"
                size="large"
                :loading="loading"
                @click="handleComplete"
              >
                完成支付
              </el-button>
            </div>
          </div>
        </el-card>
      </div>
    </main>

    <Footer />
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { createPaymentApi, getPaymentDetailApi, completePaymentApi } from '@/api/payment'
import { getPaymentMethodText } from '@/utils/validate'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'
import { Wallet } from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()

const loading = ref(false)
const orderNo = ref('')
const amount = ref(0)
const paymentMethod = ref('ALIPAY')
let timer = null

const formatPrice = (price) => {
  return parseFloat(price).toFixed(2)
}

const handleCancel = () => {
  ElMessage.info('已取消支付')
  router.push('/orders')
}

const handleComplete = async () => {
  loading.value = true
  try {
    // 获取支付ID
    const orderId = route.params.id

    // 完成支付
    await completePaymentApi(orderId)

    ElMessage.success('支付成功')
    router.push(`/order/success/${orderId}`)

    if (timer) {
      clearInterval(timer)
    }
  } catch (error) {
    ElMessage.error('支付失败，请重试')
  } finally {
    loading.value = false
  }
}

// 轮询支付状态
const checkPaymentStatus = async () => {
  try {
    const orderId = route.params.id
    const payment = await getPaymentDetailApi(orderId)

    if (payment && payment.status === 1) {
      if (timer) {
        clearInterval(timer)
      }
      ElMessage.success('支付成功')
      router.push(`/order/success/${orderId}`)
    }
  } catch (error) {
    console.error('查询支付状态失败:', error)
  }
}

onMounted(() => {
  // TODO: 从订单详情获取支付信息
  orderNo.value = 'ORDER' + Date.now()
  amount.value = 199.99

  // 开始轮询支付状态
  timer = setInterval(checkPaymentStatus, 3000)
})

onUnmounted(() => {
  if (timer) {
    clearInterval(timer)
  }
})
</script>

<style>
.payment-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.main-content {
  flex: 1;
  padding-top: 60px;
}

.page-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header h2 {
  margin: 0;
  font-size: 20px;
  color: #333;
}

.order-no {
  font-size: 14px;
  color: #999;
}

.payment-content {
  padding: 20px 0;
}

.order-info {
  background: #f9f9f9;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 30px;
}

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
  font-size: 16px;
}

.info-item .label {
  color: #666;
}

.info-item .value {
  color: #333;
  font-weight: bold;
}

.qrcode-section {
  display: flex;
  gap: 40px;
  margin-bottom: 40px;
}

.qrcode-container {
  flex: 1;
}

.qrcode-placeholder {
  background: #fff;
  border: 2px dashed #ddd;
  border-radius: 8px;
  padding: 40px;
  text-align: center;
}

.qrcode-placeholder p {
  margin-top: 16px;
  font-size: 14px;
  color: #666;
}

.payment-tips {
  flex: 1;
}

.payment-tips h4 {
  font-size: 16px;
  color: #333;
  margin-bottom: 16px;
}

.payment-tips ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.payment-tips li {
  padding: 8px 0;
  font-size: 14px;
  color: #666;
  position: relative;
  padding-left: 20px;
}

.payment-tips li::before {
  content: '•';
  position: absolute;
  left: 0;
  color: #409EFF;
  font-weight: bold;
}

.payment-actions {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin-top: 40px;
}

@media (max-width: 768px) {
  .qrcode-section {
    flex-direction: column;
    gap: 20px;
  }

  .info-item {
    flex-direction: column;
    gap: 4px;
  }
}
</style>
