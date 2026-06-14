#!/bin/bash

# 电商平台微服务启动脚本

echo "======================================"
echo "电商平台微服务启动脚本"
echo "======================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查Java版本
echo -e "${YELLOW}检查Java环境...${NC}"
if ! command -v java &> /dev/null; then
    echo -e "${RED}错误: 未找到Java，请先安装JDK 17+${NC}"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 17 ]; then
    echo -e "${RED}错误: Java版本过低，需要JDK 17+，当前版本: $JAVA_VERSION${NC}"
    exit 1
fi

echo -e "${GREEN}Java环境检查通过 (JDK $JAVA_VERSION)${NC}"

# 检查Maven
echo -e "${YELLOW}检查Maven环境...${NC}"
if ! command -v mvn &> /dev/null; then
    echo -e "${RED}错误: 未找到Maven，请先安装Maven${NC}"
    exit 1
fi

echo -e "${GREEN}Maven环境检查通过${NC}"

# 检查MySQL
echo -e "${YELLOW}检查MySQL服务...${NC}"
if ! command -v mysql &> /dev/null; then
    echo -e "${YELLOW}警告: 未找到MySQL客户端，但服务可能仍在运行${NC}"
fi

# 检查Redis
echo -e "${YELLOW}检查Redis服务...${NC}"
if ! command -v redis-cli &> /dev/null; then
    echo -e "${YELLOW}警告: 未找到Redis客户端，但服务可能仍在运行${NC}"
fi

# 检查Nacos
echo -e "${YELLOW}检查Nacos服务...${NC}"
if curl -s http://localhost:8848/nacos &> /dev/null; then
    echo -e "${GREEN}Nacos服务运行正常${NC}"
else
    echo -e "${YELLOW}警告: Nacos服务未运行，请先启动Nacos${NC}"
    echo -e "${YELLOW}下载地址: https://nacos.io/zh-cn/docs/quick-start.html${NC}"
    echo -e "${YELLOW}启动命令: cd nacos/bin && ./startup.sh -m standalone${NC}"
fi

# 询问是否继续
echo ""
read -p "是否继续启动微服务？(y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "已取消启动"
    exit 0
fi

# 编译项目
echo ""
echo -e "${YELLOW}开始编译项目...${NC}"
mvn clean install -DskipTests
if [ $? -ne 0 ]; then
    echo -e "${RED}编译失败，请检查错误信息${NC}"
    exit 1
fi
echo -e "${GREEN}编译成功${NC}"

# 启动服务
echo ""
echo -e "${YELLOW}启动微服务...${NC}"

# 定义服务列表
services=(
    "ecommerce-registry:注册中心"
    "ecommerce-gateway:API网关"
    "ecommerce-user:用户服务"
    "ecommerce-product:商品服务"
    "ecommerce-order:订单服务"
    "ecommerce-payment:支付服务"
)

# 启动各个服务
for service in "${services[@]}"; do
    IFS=':' read -ra ADDR <<< "$service"
    module_name="${ADDR[0]}"
    service_name="${ADDR[1]}"
    
    echo ""
    echo -e "${YELLOW}正在启动 ${service_name}...${NC}"
    
    cd "$module_name"
    nohup mvn spring-boot:run > ../logs/${module_name}.log 2>&1 &
    cd ..
    
    echo -e "${GREEN}${service_name} 启动中...${NC}"
    sleep 3
done

echo ""
echo "======================================"
echo -e "${GREEN}所有微服务启动完成！${NC}"
echo "======================================"
echo ""
echo "服务访问地址："
echo "  - Nacos控制台: http://localhost:8848/nacos"
echo "  - API网关: http://localhost:9000"
echo "  - 用户服务: http://localhost:8001"
echo "  - 商品服务: http://localhost:8002"
echo "  - 订单服务: http://localhost:8003"
echo "  - 支付服务: http://localhost:8004"
echo ""
echo "日志文件位置: ./logs/"
echo ""
echo "停止服务: ./stop.sh"
echo "======================================"
