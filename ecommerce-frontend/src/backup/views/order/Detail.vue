<template>
  <div class="order-detail">
    <el-card v-if="order" class="order-card">
      <template #header>
        <div class="card-header">
          <span>订单详情</span>
          <el-tag :type="statusType">{{ statusText }}</el-tag>
        </div>
      </template>
      
      <div class="order-info">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="订单编号">{{ order.id }}</el-descriptions-item>
          <el-descriptions-item label="下单时间">{{ formatDate(order.createTime) }}</el-descriptions-item>
          <el-descriptions-item label="订单金额">
            <span class="amount">¥{{ order.totalAmount.toFixed(2) }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="收货人">{{ order.receiverName }}</el-descriptions-item>
          <el-descriptions-item label="联系电话">{{ order.receiverPhone }}</el-descriptions-item>
          <el-descriptions-item label="收货地址" :span="2">{{ order.receiverAddress }}</el-descriptions-item>
        </el-descriptions>
      </div>
      
      <el-divider />
      
      <div class="order-items">
        <h3>商品信息</h3>
        <el-table :data="order.items" style="width: 100%">
          <el-table-column prop="productName" label="商品名称" />
          <el-table-column prop="price" label="单价" width="120">
            <template #default="{ row }">
              ¥{{ row.price.toFixed(2) }}
            </template>
          </el-table-column>
          <el-table-column prop="quantity" label="数量" width="100" />
          <el-table-column label="小计" width="120">
            <template #default="{ row }">
              ¥{{ (row.price * row.quantity).toFixed(2) }}
            </template>
          </el-table-column>
        </el-table>
      </div>
      
      <div class="order-actions" v-if="order.status === 'PENDING'">
        <el-button type="primary" @click="goToPayment">
          立即支付
        </el-button>
        <el-button @click="cancelOrder" type="danger">
          取消订单
        </el-button>
      </div>
    </el-card>
    
    <el-empty v-else description="订单不存在" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getOrderById, cancelOrder as cancelOrderApi } from '@/api/order'
import { formatDate } from '@/utils/validate'

const route = useRoute()
const router = useRouter()

const order = ref(null)

const statusType = computed(() => {
  const statusMap = {
    PENDING: 'warning',
    PAID: 'success',
    SHIPPED: 'primary',
    COMPLETED: 'success',
    CANCELLED: 'info'
  }
  return statusMap[order.value?.status] || 'info'
})

const statusText = computed(() => {
  const statusMap = {
    PENDING: '待支付',
    PAID: '已支付',
    SHIPPED: '已发货',
    COMPLETED: '已完成',
    CANCELLED: '已取消'
  }
  return statusMap[order.value?.status] || '未知'
})

const loadOrder = async () => {
  try {
    const id = route.params.id
    order.value = await getOrderById(id)
  } catch (error) {
    ElMessage.error(error.message || '加载订单详情失败')
  }
}

const goToPayment = () => {
  router.push(`/payment/${order.value.id}`)
}

const cancelOrder = async () => {
  try {
    await ElMessageBox.confirm('确定要取消该订单吗？', '确认取消', {
      type: 'warning'
    })
    
    await cancelOrderApi(order.value.id)
    ElMessage.success('订单已取消')
    await loadOrder()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(error.message || '取消订单失败')
    }
  }
}

onMounted(() => {
  loadOrder()
})
</script>

<style>
.order-detail {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.order-info {
  margin-bottom: 20px;
}

.amount {
  color: #f56c6c;
  font-size: 20px;
  font-weight: bold;
}

.order-items h3 {
  margin: 0 0 15px 0;
  color: #303133;
}

.order-actions {
  margin-top: 30px;
  display: flex;
  gap: 15px;
}
</style>
