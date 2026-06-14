import { defineStore } from 'pinia'
import { ref } from 'vue'
import {
  getUserOrdersApi,
  createOrderApi,
  getOrderDetailApi,
  cancelOrderApi
} from '@/api/order'

export const useOrderStore = defineStore('order', () => {
  const orderList = ref([])
  const orderDetail = ref(null)
  const loading = ref(false)

  // 获取用户订单列表
  const fetchUserOrders = async (userId) => {
    try {
      loading.value = true
      const data = await getUserOrdersApi(userId)
      orderList.value = data
      return data
    } catch (error) {
      console.error('获取订单列表失败:', error)
      return []
    } finally {
      loading.value = false
    }
  }

  // 创建订单
  const createOrder = async (orderData) => {
    try {
      loading.value = true
      const data = await createOrderApi(orderData)
      return data
    } catch (error) {
      console.error('创建订单失败:', error)
      return null
    } finally {
      loading.value = false
    }
  }

  // 获取订单详情
  const fetchOrderDetail = async (orderId) => {
    try {
      loading.value = true
      const data = await getOrderDetailApi(orderId)
      orderDetail.value = data
      return data
    } catch (error) {
      console.error('获取订单详情失败:', error)
      return null
    } finally {
      loading.value = false
    }
  }

  // 取消订单
  const cancelOrder = async (orderId) => {
    try {
      await cancelOrderApi(orderId)
      // 从列表中移除该订单
      const index = orderList.value.findIndex(order => order.id === orderId)
      if (index > -1) {
        orderList.value.splice(index, 1)
      }
      return true
    } catch (error) {
      console.error('取消订单失败:', error)
      return false
    }
  }

  return {
    orderList,
    orderDetail,
    loading,
    fetchUserOrders,
    createOrder,
    fetchOrderDetail,
    cancelOrder
  }
})
