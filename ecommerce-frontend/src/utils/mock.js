// 模拟登录接口（用于测试，实际应该调用后端API）
export function mockLogin(data) {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve({
        code: 200,
        data: {
          token: 'mock-token-' + Date.now(),
          userId: 1,
          username: data.username,
          nickname: data.username
        },
        message: '登录成功'
      })
    }, 500)
  })
}

// 模拟注册接口（用于测试，实际应该调用后端API）
export function mockRegister(data) {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve({
        code: 200,
        data: {
          userId: Math.floor(Math.random() * 1000) + 1,
          username: data.username,
          phone: data.phone,
          email: data.email
        },
        message: '注册成功'
      })
    }, 500)
  })
}
