<template>
  <div class="order-list-page">
    <Header />

    <main class="main-content">
      <div class="page-container">
        <h2 class="page-title">我的订单</h2>

        <!-- 订单列表 -->
        <div v-loading="orderStore.loading" class="order-list">
          <el-empty
            v-if="!orderStore.loading && orderStore.orderList.length === 0"
            description="暂无订单"
          >
            <el-button type="primary" @click="$router.push('/products')">
              去购物
            </el-button>
          </el-empty>

          <div
            v-for="order in orderStore.orderList"
            :key="order.id"
            class="order-card"
          >
            <div class="order-header">
              <div class="order-info">
                <span class="order-no">订单号：{{ order.orderNo }}</span>
                <span class="order-time">{{ formatDateTime(order.createTime) }}</span>
              </div>
              <el-tag :type="getOrderStatusType(order.status)">
                {{ getOrderStatusText(order.status) }}
              </el-tag>
            </div>

            <div class="order-items">
              <div
                v-for="item in order.items"
                :key="item.id"
                class="order-item"
              >
                <el-image
                  :src="item.imageUrl"
                  fit="cover"
                  class="item-image"
                />

                <div class="item-info">
                  <h4 class="item-name">{{ item.productName }}</h4>
                  <p class="item-spec">数量：{{ item.quantity }}</p>
                </div>

                <div class="item-price">
                  ¥{{ formatPrice(item.price) }}
                </div>
              </div>
            </div>

            <div class="order-footer">
              <div class="order-total">
                <span class="label">订单总额：</span>
                <span class="value">¥{{ formatPrice(order.totalAmount) }}</span>
              </div>

              <div class="order-actions">
                <el-button
                  size="small"
                  @click="goToDetail(order.id)"
                >
                  查看详情
                </el-button>

                <el-button
                  v-if="order.status === 0"
                  type="danger"
                  size="small"
                  @click="handleCancel(order.id)"
                >
                  取消订单
                </el-button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>

    <Footer />
  </div>
</template>

<script setup>
import { computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { useOrderStore } from '@/stores/order'
import { formatDateTime, getOrderStatusText, getOrderStatusType } from '@/utils/validate'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'

const router = useRouter()
const userStore = useUserStore()
const orderStore = useOrderStore()

const formatPrice = (price) => {
  return parseFloat(price).toFixed(2)
}

const goToDetail = (orderId) => {
  router.push(`/orders/${orderId}`)
}

const handleCancel = (orderId) => {
  ElMessageBox.confirm(
    '确定要取消该订单吗？',
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    const success = await orderStore.cancelOrder(orderId)
    if (success) {
      ElMessage.success('订单已取消')
    }
  })
}

onMounted(async () => {
  if (userStore.userInfo?.userId) {
    await orderStore.fetchUserOrders(userStore.userInfo.userId)
  }
})
</script>

<style>
.order-list-page {
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

.order-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
  min-height: 400px;
}

.order-card {
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 16px;
  border-bottom: 1px solid #f0f0f0;
  margin-bottom: 16px;
}

.order-info {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.order-no {
  font-size: 14px;
  color: #333;
  font-weight: 500;
}

.order-time {
  font-size: 12px;
  color: #999;
}

.order-items {
  display: flex;
  flex-direction: column;
  gap: 16px;
  margin-bottom: 16px;
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
  font-size: 16px;
  color: #F56C6C;
  font-weight: bold;
}

.order-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 16px;
  border-top: 1px solid #f0f0f0;
}

.order-total {
  display: flex;
  align-items: baseline;
  gap: 8px;
}

.order-total .label {
  font-size: 14px;
  color: #666;
}

.order-total .value {
  font-size: 24px;
  color: #F56C6C;
  font-weight: bold;
}

.order-actions {
  display: flex;
  gap: 12px;
}
</style>
