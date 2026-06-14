#!/bin/bash

echo "======================================"
echo "检查所有服务状态"
echo "======================================"

# 定义服务
declare -A SERVICES=(
    ["Nacos"]="8848"
    ["User Service"]="8001"
    ["Product Service"]="8002"
    ["Gateway"]="9000"
    ["Frontend"]="3000"
)

echo ""
echo "端口占用情况："
echo "--------------------------------------"

ALL_RUNNING=true

for service in "${!SERVICES[@]}"; do
    port=${SERVICES[$service]}
    pid=$(lsof -ti:$port 2>/dev/null)

    if [ -n "$pid" ]; then
        process=$(ps -p $pid -o comm= 2>/dev/null)
        echo "✅ $service (端口 $port) - 运行中 (PID: $pid, $process)"
    else
        echo "❌ $service (端口 $port) - 未运行"
        ALL_RUNNING=false
    fi
done

echo ""
echo "======================================"

if [ "$ALL_RUNNING" = true ]; then
    echo "✅ 所有服务都在运行！"
    echo ""
    echo "下一步："
    echo "1. 访问Nacos控制台: http://localhost:8848/nacos"
    echo "2. 确认服务IP为127.0.0.1"
    echo "3. 测试前端: http://localhost:3000"
else
    echo "❌ 部分服务未运行"
    echo ""
    echo "需要在IDEA中启动："
    echo "1. ecommerce-registry (Nacos)"
    echo "2. ecommerce-user"
    echo "3. ecommerce-product"
    echo "4. ecommerce-gateway"
    echo "5. 前端: cd ecommerce-frontend && npm run dev"
fi

echo "======================================"
