/**
 * 验证手机号
 */
export function validatePhone(phone) {
  const reg = /^1[3-9]\d{9}$/
  return reg.test(phone)
}

/**
 * 验证邮箱
 */
export function validateEmail(email) {
  const reg = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
  return reg.test(email)
}

/**
 * 验证密码（6-20位）
 */
export function validatePassword(password) {
  const reg = /^.{6,20}$/
  return reg.test(password)
}

/**
 * 格式化金额
 */
export function formatMoney(amount) {
  if (amount === null || amount === undefined) {
    return '0.00'
  }
  return parseFloat(amount).toFixed(2)
}

/**
 * 格式化日期时间
 */
export function formatDateTime(date) {
  if (!date) return ''
  const d = new Date(date)
  const year = d.getFullYear()
  const month = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  const hour = String(d.getHours()).padStart(2, '0')
  const minute = String(d.getMinutes()).padStart(2, '0')
  const second = String(d.getSeconds()).padStart(2, '0')
  return `${year}-${month}-${day} ${hour}:${minute}:${second}`
}

/**
 * 格式化日期
 */
export function formatDate(date) {
  if (!date) return ''
  const d = new Date(date)
  const year = d.getFullYear()
  const month = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
}

/**
 * 获取订单状态文本
 */
export function getOrderStatusText(status) {
  const statusMap = {
    0: '待支付',
    1: '已支付',
    2: '已取消'
  }
  return statusMap[status] || '未知状态'
}

/**
 * 获取订单状态颜色
 */
export function getOrderStatusColor(status) {
  const colorMap = {
    0: 'warning',
    1: 'success',
    2: 'info'
  }
  return colorMap[status] || 'default'
}

/**
 * 获取支付方式文本
 */
export function getPaymentMethodText(method) {
  const methodMap = {
    'ALIPAY': '支付宝',
    'WECHAT': '微信支付'
  }
  return methodMap[method] || '未知支付方式'
}

/**
 * 存储token到localStorage
 */
export function setToken(token) {
  return localStorage.setItem('token', token)
}

/**
 * 从localStorage获取token
 */
export function getToken() {
  return localStorage.getItem('token')
}

/**
 * 从localStorage移除token
 */
export function removeToken() {
  return localStorage.removeItem('token')
}

/**
 * 存储用户信息到localStorage
 */
export function setUserInfo(userInfo) {
  return localStorage.setItem('userInfo', JSON.stringify(userInfo))
}

/**
 * 从localStorage获取用户信息
 */
export function getUserInfo() {
  const userInfo = localStorage.getItem('userInfo')
  return userInfo ? JSON.parse(userInfo) : null
}

/**
 * 从localStorage移除用户信息
 */
export function removeUserInfo() {
  return localStorage.removeItem('userInfo')
}
