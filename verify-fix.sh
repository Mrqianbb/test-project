#!/bin/bash

echo "======================================"
echo "验证503错误修复"
echo "======================================"

echo ""
echo "1. 检查Nacos服务注册..."
echo ""
echo "ecommerce-user服务IP:"
curl -s "http://localhost:8848/nacos/v1/ns/instance/list?serviceName=ecommerce-user" | grep '"ip"' | head -1

echo ""
echo "ecommerce-product服务IP:"
curl -s "http://localhost:8848/nacos/v1/ns/instance/list?serviceName=ecommerce-product" | grep '"ip"' | head -1

echo ""
echo "2. 测试User服务注册接口..."
echo ""
echo "直接访问: http://localhost:8001/users/register"
RESPONSE=$(curl -s -X POST http://localhost:8001/users/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test123","password":"123456","nickname":"测试用户123"}' \
  --connect-timeout 5 --max-time 10)

if echo "$RESPONSE" | grep -q "200\|success"; then
    echo "✅ 直接访问成功"
else
    echo "❌ 直接访问失败: $RESPONSE"
fi

echo ""
echo "通过Gateway: http://localhost:9000/api/user/users/register"
RESPONSE=$(curl -s -X POST http://localhost:9000/api/user/users/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test124","password":"123456","nickname":"测试用户124"}' \
  --connect-timeout 5 --max-time 10)

if echo "$RESPONSE" | grep -q "200\|success"; then
    echo "✅ Gateway转发成功 - 503错误已修复！"
    echo "响应: $RESPONSE"
else
    echo "❌ Gateway转发失败"
    echo "响应: $RESPONSE"
    echo ""
    echo "可能原因:"
    echo "  - 服务IP仍为192.168.124.5，需要在IDEA中重启User和Product服务"
    echo "  - Gateway未正确发现服务"
fi

echo ""
echo "3. 测试Product服务..."
echo ""
echo "通过Gateway: http://localhost:9000/api/product/products/list"
RESPONSE=$(curl -s http://localhost:9000/api/product/products/list \
  --connect-timeout 5 --max-time 10)

if echo "$RESPONSE" | grep -q "name\|price"; then
    echo "✅ 商品列表获取成功"
    PRODUCT_COUNT=$(echo "$RESPONSE" | grep -o '"name"' | wc -l | tr -d ' ')
    echo "商品数量: $PRODUCT_COUNT"
else
    echo "❌ 商品列表获取失败"
    echo "响应: $RESPONSE"
fi

echo ""
echo "======================================"
echo "验证完成"
echo "======================================"
