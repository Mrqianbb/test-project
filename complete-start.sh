#!/bin/bash

# 完整的项目启动脚本

echo "======================================"
echo "电商平台微服务完整启动脚本"
echo "======================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 设置环境变量
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_221.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="/usr/local/mysql-8.0.30-macos12-x86_64/bin:$PATH"

echo -e "${GREEN}✓ 环境变量已设置${NC}"
echo ""

# 步骤1：检查Java
echo "步骤 1/5: 检查Java环境"
echo "-----------------------------------"
java -version 2>&1 | head -n 1
echo -e "${GREEN}✓ Java环境检查通过${NC}"
echo ""

# 步骤2：检查并启动MySQL
echo "步骤 2/5: 检查MySQL服务"
echo "-----------------------------------"
if pgrep -x "mysqld" > /dev/null; then
    echo -e "${GREEN}✓ MySQL服务正在运行${NC}"
else
    echo -e "${YELLOW}启动MySQL服务...${NC}"
    sudo /usr/local/mysql-8.0.30-macos12-x86_64/support-files/mysql.server start
    sleep 3
fi
echo ""

# 步骤3：初始化数据库
echo "步骤 3/5: 初始化数据库"
echo "-----------------------------------"
echo "请输入MySQL root密码（如果没有密码直接回车）："
read -s mysql_password

# 检查数据库是否存在
if mysql -u root -p$mysql_password -e "USE ecommerce;" 2>/dev/null; then
    echo -e "${GREEN}✓ 数据库已存在${NC}"
else
    echo -e "${YELLOW}初始化数据库...${NC}"
    mysql -u root -p$mysql_password < sql/init.sql
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ 数据库初始化成功${NC}"
    else
        echo -e "${RED}✗ 数据库初始化失败${NC}"
        exit 1
    fi
fi
echo ""

# 步骤4：检查并启动Nacos
echo "步骤 4/5: 检查Nacos服务"
echo "-----------------------------------"
if [ -d "$HOME/nacos" ]; then
    echo -e "${GREEN}✓ Nacos已下载${NC}"

    # 检查Nacos是否运行
    if curl -s http://localhost:8848/nacos &> /dev/null; then
        echo -e "${GREEN}✓ Nacos正在运行${NC}"
    else
        echo -e "${YELLOW}启动Nacos...${NC}"
        cd ~/nacos/bin
        ./startup.sh -m standalone
        cd - > /dev/null
        sleep 5
        echo -e "${GREEN}✓ Nacos启动中${NC}"
    fi
else
    echo -e "${YELLOW}下载并启动Nacos...${NC}"
    NACOS_VERSION="2.2.3"
    cd /tmp
    curl -O https://github.com/alibaba/nacos/releases/download/${NACOS_VERSION}/nacos-server-${NACOS_VERSION}.tar.gz 2>/dev/null
    if [ -f "nacos-server-${NACOS_VERSION}.tar.gz" ]; then
        tar -xzf nacos-server-${NACOS_VERSION}.tar.gz
        mv nacos ~/nacos
        cd ~/nacos/bin
        ./startup.sh -m standalone
        cd - > /dev/null
        sleep 5
        echo -e "${GREEN}✓ Nacos下载并启动成功${NC}"
    else
        echo -e "${RED}✗ Nacos下载失败${NC}"
        echo -e "${YELLOW}请手动下载: https://github.com/alibaba/nacos/releases/download/2.2.3/nacos-server-2.2.3.tar.gz${NC}"
    fi
fi
echo ""

# 步骤5：编译并启动项目
echo "步骤 5/5: 编译并启动项目"
echo "-----------------------------------"

# 编译项目
echo -e "${YELLOW}编译项目...${NC}"
./mvnw clean install -DskipTests
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ 编译失败${NC}"
    exit 1
fi
echo -e "${GREEN}✓ 编译成功${NC}"

# 创建日志目录
mkdir -p logs

# 启动服务
echo ""
echo -e "${YELLOW}启动微服务...${NC}"

services=(
    "ecommerce-registry:注册中心"
    "ecommerce-gateway:API网关"
    "ecommerce-user:用户服务"
    "ecommerce-product:商品服务"
    "ecommerce-order:订单服务"
    "ecommerce-payment:支付服务"
)

for service in "${services[@]}"; do
    IFS=':' read -ra ADDR <<< "$service"
    module_name="${ADDR[0]}"
    service_name="${ADDR[1]}"

    echo ""
    echo -e "${YELLOW}启动 ${service_name}...${NC}"
    cd "$module_name"
    nohup ../mvnw spring-boot:run > ../logs/${module_name}.log 2>&1 &
    echo $! > ../logs/${module_name}.pid
    cd ..
    sleep 3
done

echo ""
echo "======================================"
echo -e "${GREEN}所有微服务启动完成！${NC}"
echo "======================================"
echo ""
echo "服务访问地址："
echo "  - Nacos控制台: http://localhost:8848/nacos (nacos/nacos)"
echo "  - API网关: http://localhost:9000"
echo "  - 用户服务: http://localhost:8001"
echo "  - 商品服务: http://localhost:8002"
echo "  - 订单服务: http://localhost:8003"
echo "  - 支付服务: http://localhost:8004"
echo ""
echo "查看日志: tail -f logs/*.log"
echo "停止服务: ./stop.sh"
echo ""
