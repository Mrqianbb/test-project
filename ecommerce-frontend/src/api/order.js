import request from '@/utils/request'

/**
 * 创建订单
 */
export function createOrderApi(data) {
  return request({
    url: '/orders',
    method: 'post',
    data
  })
}

/**
 * 获取订单详情
 */
export function getOrderDetailApi(orderId) {
  return request({
    url: `/orders/${orderId}`,
    method: 'get'
  })
}

/**
 * 获取用户订单列表
 */
export function getUserOrdersApi(userId) {
  return request({
    url: `/orders/user/${userId}`,
    method: 'get'
  })
}

/**
 * 取消订单
 */
export function cancelOrderApi(orderId) {
  return request({
    url: `/orders/${orderId}/cancel`,
    method: 'post'
  })
}

/**
 * 更新订单状态
 */
export function updateOrderStatusApi(orderId, status) {
  return request({
    url: `/orders/${orderId}/status`,
    method: 'post',
    params: { status }
  })
}

// 导出别名，方便使用
export const createOrder = createOrderApi
export const getOrderById = getOrderDetailApi
export const getUserOrders = getUserOrdersApi
export const cancelOrder = cancelOrderApi
export const updateOrderStatus = updateOrderStatusApi
