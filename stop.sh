#!/bin/bash

# 电商平台微服务停止脚本

echo "======================================"
echo "电商平台微服务停止脚本"
echo "======================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 查找所有Java进程
echo -e "${YELLOW}查找运行中的微服务...${NC}"

# 定义服务名称列表
services=(
    "ecommerce-registry"
    "ecommerce-gateway"
    "ecommerce-user"
    "ecommerce-product"
    "ecommerce-order"
    "ecommerce-payment"
)

stopped_count=0

for service in "${services[@]}"; do
    # 查找对应服务的Java进程
    pid=$(ps aux | grep "$service" | grep "spring-boot:run" | grep -v grep | awk '{print $2}')
    
    if [ -n "$pid" ]; then
        echo -e "${YELLOW}停止 $service (PID: $pid)...${NC}"
        kill $pid
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}$service 已停止${NC}"
            ((stopped_count++))
        else
            echo -e "${RED}停止 $service 失败${NC}"
        fi
    else
        echo -e "${YELLOW}$service 未运行${NC}"
    fi
done

echo ""
echo "======================================"
if [ $stopped_count -gt 0 ]; then
    echo -e "${GREEN}已停止 $stopped_count 个服务${NC}"
else
    echo -e "${YELLOW}没有找到运行中的服务${NC}"
fi
echo "======================================"
