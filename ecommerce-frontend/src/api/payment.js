import request from '@/utils/request'

/**
 * 创建支付
 */
export function createPaymentApi(data) {
  return request({
    url: '/payments',
    method: 'post',
    data
  })
}

/**
 * 获取支付详情
 */
export function getPaymentDetailApi(paymentId) {
  return request({
    url: `/payments/${paymentId}`,
    method: 'get'
  })
}

/**
 * 完成支付
 */
export function completePaymentApi(paymentId) {
  return request({
    url: `/payments/${paymentId}/complete`,
    method: 'post'
  })
}

/**
 * 根据订单ID查询支付
 */
export function getPaymentByOrderApi(orderId) {
  return request({
    url: `/payments/order/${orderId}`,
    method: 'get'
  })
}
