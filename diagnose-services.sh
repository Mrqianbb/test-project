#!/bin/bash

# 服务诊断脚本

echo "======================================"
echo "服务状态诊断"
echo "======================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 检查函数
check_service() {
    local name=$1
    local port=$2
    local url=$3

    echo -n "检查 $name (端口 $port)... "

    if lsof -i :$port > /dev/null 2>&1; then
        echo -e "${GREEN}✓ 运行中${NC}"

        if [ -n "$url" ]; then
            echo -n "  测试 $url... "
            if curl -s -m 3 $url > /dev/null 2>&1; then
                echo -e "${GREEN}✓ 可访问${NC}"
            else
                echo -e "${YELLOW}⚠ 无法访问${NC}"
            fi
        fi
    else
        echo -e "${RED}✗ 未运行${NC}"
    fi
}

# 检查Nacos
echo "1. 基础服务"
echo "-----------------------------------"
check_service "Nacos" "8848" "http://localhost:8848/nacos/index.html"
check_service "MySQL" "3306"
check_service "Redis" "6379" ""
echo ""

# 检查微服务
echo "2. 微服务"
echo "-----------------------------------"
check_service "API网关" "9000" "http://localhost:9000"
check_service "用户服务" "8001" "http://localhost:8001"
check_service "商品服务" "8002" "http://localhost:8002"
check_service "订单服务" "8003" "http://localhost:8003"
check_service "支付服务" "8004" "http://localhost:8004"
echo ""

# 检查编译状态
echo "3. 项目编译状态"
echo "-----------------------------------"
if [ -f "ecommerce-gateway/target/ecommerce-gateway-1.0.0.jar" ]; then
    echo -e "${GREEN}✓ API网关已编译${NC}"
else
    echo -e "${RED}✗ API网关未编译${NC}"
fi

if [ -f "ecommerce-user/target/ecommerce-user-1.0.0.jar" ]; then
    echo -e "${GREEN}✓ 用户服务已编译${NC}"
else
    echo -e "${RED}✗ 用户服务未编译${NC}"
fi

if [ -f "ecommerce-product/target/ecommerce-product-1.0.0.jar" ]; then
    echo -e "${GREEN}✓ 商品服务已编译${NC}"
else
    echo -e "${RED}✗ 商品服务未编译${NC}"
fi

if [ -f "ecommerce-order/target/ecommerce-order-1.0.0.jar" ]; then
    echo -e "${GREEN}✓ 订单服务已编译${NC}"
else
    echo -e "${RED}✗ 订单服务未编译${NC}"
fi

if [ -f "ecommerce-payment/target/ecommerce-payment-1.0.0.jar" ]; then
    echo -e "${GREEN}✓ 支付服务已编译${NC}"
else
    echo -e "${RED}✗ 支付服务未编译${NC}"
fi
echo ""

echo "======================================"
echo "诊断完成"
echo "======================================"
echo ""
echo "建议操作："
echo ""
echo "如果项目未编译："
echo "  ./compile-and-start.sh"
echo ""
echo "如果服务未启动："
echo "  方式A（推荐）：在IntelliJ IDEA中启动各服务"
echo "  方式B：运行 ./start.sh"
echo ""
echo "查看详细指南："
echo "  cat COMPLETE_START_GUIDE.md"
echo ""
