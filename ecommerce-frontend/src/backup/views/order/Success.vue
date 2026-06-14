<template>
  <div class="success-container">
    <el-result icon="success" title="下单成功！" sub-title="您的订单已提交，我们会尽快为您处理">
      <template #extra>
        <div class="order-info">
          <p>订单编号：{{ orderId }}</p>
          <p>下单时间：{{ orderTime }}</p>
        </div>
        
        <div class="actions">
          <el-button type="primary" @click="viewOrder">
            查看订单
          </el-button>
          <el-button @click="continueShopping">
            继续购物
          </el-button>
        </div>
      </template>
    </el-result>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

const orderId = computed(() => route.params.id)
const orderTime = computed(() => {
  const now = new Date()
  return now.toLocaleString('zh-CN')
})

const viewOrder = () => {
  router.push(`/orders/${orderId.value}`)
}

const continueShopping = () => {
  router.push('/')
}
</script>

<style>
.success-container {
  padding: 40px 20px;
  min-height: calc(100vh - 120px);
}

.order-info {
  margin: 30px 0;
  padding: 20px;
  background: #f5f7fa;
  border-radius: 8px;
}

.order-info p {
  margin: 10px 0;
  color: #606266;
  font-size: 14px;
}

.actions {
  display: flex;
  justify-content: center;
  gap: 15px;
}
</style>
