#!/bin/bash

echo "======================================"
echo "测试后端API"
echo "======================================"

GATEWAY_URL="http://localhost:9000/api"

# 测试1: 用户注册
echo ""
echo "测试1: 用户注册"
echo "POST $GATEWAY_URL/user/users/register"
curl -X POST $GATEWAY_URL/user/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "test001",
    "password": "123456",
    "nickname": "测试用户001",
    "phone": "13800138001",
    "email": "test001@example.com"
  }' \
  -w "\nHTTP状态码: %{http_code}\n" \
  -v 2>&1 | grep -A 5 "HTTP/"

echo ""
echo "======================================"
echo "测试完成"
echo "======================================"
