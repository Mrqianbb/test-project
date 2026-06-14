#!/bin/bash

echo "======================================"
echo "快速API测试"
echo "======================================"

# 设置超时时间
TIMEOUT=5

echo ""
echo "测试1: 直接访问User服务注册..."
timeout $TIMEOUT curl -X POST http://localhost:8001/users/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test999","password":"123456","nickname":"测试用户999"}' \
  2>&1 || echo "❌ 请求超时或失败"

echo ""
echo "测试2: 通过Gateway访问User服务注册..."
timeout $TIMEOUT curl -X POST http://localhost:9000/api/user/users/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test998","password":"123456","nickname":"测试用户998"}' \
  2>&1 || echo "❌ 请求超时或失败"

echo ""
echo "测试3: 直接访问Product服务获取列表..."
timeout $TIMEOUT curl http://localhost:8002/products/list 2>&1 | head -20 || echo "❌ 请求超时或失败"

echo ""
echo "测试4: 通过Gateway访问Product服务..."
timeout $TIMEOUT curl http://localhost:9000/api/product/products/list 2>&1 | head -20 || echo "❌ 请求超时或失败"

echo ""
echo "======================================"
echo "测试完成"
echo "======================================"
