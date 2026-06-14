#!/bin/bash

echo "======================================"
echo "快速诊断503错误"
echo "======================================"

echo ""
echo "1. 检查服务端口..."
echo "--------------------------------------"
for port in 8848 8001 8002 9000; do
    if lsof -ti:$port > /dev/null 2>&1; then
        pid=$(lsof -ti:$port)
        echo "✓ 端口 $port - 运行中 (PID: $pid)"
    else
        echo "✗ 端口 $port - 未运行"
    fi
done

echo ""
echo "2. 检查Nacos服务注册..."
echo "--------------------------------------"
echo "User服务IP:"
USER_IP=$(curl -s "http://localhost:8848/nacos/v1/ns/instance/list?serviceName=ecommerce-user" | grep -o '"ip":"[^"]*"' | head -1 | cut -d'"' -f4)
if [ -n "$USER_IP" ]; then
    echo "  IP: $USER_IP"
    if [ "$USER_IP" = "127.0.0.1" ]; then
        echo "  ✓ IP正确"
    else
        echo "  ✗ IP错误！应该是127.0.0.1"
    fi
else
    echo "  ✗ User服务未注册"
fi

echo ""
echo "Product服务IP:"
PRODUCT_IP=$(curl -s "http://localhost:8848/nacos/v1/ns/instance/list?serviceName=ecommerce-product" | grep -o '"ip":"[^"]*"' | head -1 | cut -d'"' -f4)
if [ -n "$PRODUCT_IP" ]; then
    echo "  IP: $PRODUCT_IP"
    if [ "$PRODUCT_IP" = "127.0.0.1" ]; then
        echo "  ✓ IP正确"
    else
        echo "  ✗ IP错误！应该是127.0.0.1"
    fi
else
    echo "  ✗ Product服务未注册"
fi

echo ""
echo "3. 测试API..."
echo "--------------------------------------"
echo "测试直接访问User服务..."
DIRECT_RESULT=$(curl -s -X POST http://localhost:8001/users/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test999","password":"123456","nickname":"测试用户999"}' \
  --connect-timeout 3 --max-time 5 2>&1)
if echo "$DIRECT_RESULT" | grep -q "200\|success"; then
    echo "  ✓ 直接访问成功"
else
    echo "  ✗ 直接访问失败"
    echo "  错误: $DIRECT_RESULT"
fi

echo ""
echo "测试通过Gateway访问..."
GATEWAY_RESULT=$(curl -s -X POST http://localhost:9000/api/user/users/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test998","password":"123456","nickname":"测试用户998"}' \
  --connect-timeout 3 --max-time 5 2>&1)
if echo "$GATEWAY_RESULT" | grep -q "200\|success"; then
    echo "  ✓ Gateway转发成功 - 503错误已修复！"
else
    echo "  ✗ Gateway转发失败"
    echo "  错误: $GATEWAY_RESULT"
fi

echo ""
echo "======================================"
echo "诊断完成"
echo "======================================"
echo ""
echo "诊断结果："
if [ -n "$USER_IP" ] && [ "$USER_IP" = "127.0.0.1" ] && echo "$GATEWAY_RESULT" | grep -q "200\|success"; then
    echo "✅ 503错误已修复！所有服务正常。"
else
    echo "❌ 仍存在问题，请查看上面的诊断结果。"
    echo ""
    echo "建议："
    if [ -z "$USER_IP" ]; then
        echo "1. 检查User服务是否启动"
    elif [ "$USER_IP" != "127.0.0.1" ]; then
        echo "1. 检查application.yml配置，确认包含 ip: 127.0.0.1"
        echo "2. 重启User服务"
    fi
    if ! echo "$GATEWAY_RESULT" | grep -q "200\|success"; then
        echo "3. 检查Gateway日志，查看是否有错误"
    fi
fi
echo ""
echo "详细诊断指南：/Users/zyq/IdeaProjects/TestProject/DEBUG_503_AGAIN.md"
