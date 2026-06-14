#!/bin/bash

# 环境检查脚本

echo "======================================"
echo "电商平台环境检查脚本"
echo "======================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查计数器
pass_count=0
fail_count=0

# 检查函数
check_service() {
    local name=$1
    local command=$2
    local expected=$3
    
    echo -n "检查 $name... "
    
    if eval "$command" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ 通过${NC}"
        ((pass_count++))
        return 0
    else
        echo -e "${RED}✗ 失败${NC}"
        echo -e "  提示: $expected"
        ((fail_count++))
        return 1
    fi
}

echo "1. 基础环境检查"
echo "-----------------------------------"

# 检查 Java
check_service "Java (JDK 17+)" "java -version 2>&1 | grep -q '17\\.'" "请安装 JDK 17 或更高版本"

# 检查 Java 版本详细
java_version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
if [ -n "$java_version" ]; then
    echo -e "  Java 版本: $java_version"
fi

# 检查 Maven
check_service "Maven 3.6+" "mvn -version" "请安装 Maven 3.6 或更高版本"

# 检查 Maven 版本详细
maven_version=$(mvn -version 2>&1 | head -n 1 | awk '{print $3}')
if [ -n "$maven_version" ]; then
    echo -e "  Maven 版本: $maven_version"
fi

echo ""
echo "2. 服务检查"
echo "-----------------------------------"

# 检查 MySQL
if check_service "MySQL" "mysql -u root -p$1 -e 'SELECT 1;' 2>/dev/null" "请确保 MySQL 已启动并可连接"; then
    mysql_version=$(mysql -u root -p$1 -e 'SELECT VERSION();' 2>/dev/null | tail -n 1)
    if [ -n "$mysql_version" ]; then
        echo -e "  MySQL 版本: $mysql_version"
    fi
    
    # 检查数据库
    echo -n "检查数据库 ecommerce... "
    if mysql -u root -p$1 -e "USE ecommerce;" 2>/dev/null; then
        echo -e "${GREEN}✓ 存在${NC}"
        ((pass_count++))
    else
        echo -e "${RED}✗ 不存在${NC}"
        echo -e "  提示: 请执行 mysql -u root -p < sql/init.sql 初始化数据库"
        ((fail_count++))
    fi
fi

# 检查 Redis
if check_service "Redis" "redis-cli ping" "请确保 Redis 已启动"; then
    redis_version=$(redis-cli INFO server 2>/dev/null | grep redis_version | cut -d: -f2 | tr -d '\r')
    if [ -n "$redis_version" ]; then
        echo -e "  Redis 版本: $redis_version"
    fi
fi

# 检查 Nacos
check_service "Nacos" "curl -s http://localhost:8848/nacos | grep -q 'Nacos'" "请确保 Nacos 已启动并访问 http://localhost:8848/nacos"

echo ""
echo "3. 端口检查"
echo "-----------------------------------"

# 检查端口占用
ports=(8848 3306 6379 8001 8002 8003 8004 9000)
port_names=("Nacos" "MySQL" "Redis" "用户服务" "商品服务" "订单服务" "支付服务" "API网关")

for i in "${!ports[@]}"; do
    port=${ports[$i]}
    name=${port_names[$i]}
    
    echo -n "检查端口 $port ($name)... "
    if lsof -i :$port > /dev/null 2>&1; then
        echo -e "${GREEN}✓ 使用中${NC}"
        ((pass_count++))
    else
        echo -e "${YELLOW}○ 未使用${NC}"
    fi
done

echo ""
echo "4. 项目文件检查"
echo "-----------------------------------"

# 检查 pom.xml
if [ -f "pom.xml" ]; then
    echo -e "${GREEN}✓ pom.xml 存在${NC}"
    ((pass_count++))
else
    echo -e "${RED}✗ pom.xml 不存在${NC}"
    ((fail_count++))
fi

# 检查 SQL 初始化脚本
if [ -f "sql/init.sql" ]; then
    echo -e "${GREEN}✓ sql/init.sql 存在${NC}"
    ((pass_count++))
else
    echo -e "${RED}✗ sql/init.sql 不存在${NC}"
    ((fail_count++))
fi

# 检查模块目录
modules=("ecommerce-common" "ecommerce-user" "ecommerce-product" "ecommerce-order" "ecommerce-payment" "ecommerce-gateway")
for module in "${modules[@]}"; do
    if [ -d "$module" ]; then
        echo -e "${GREEN}✓ $module 存在${NC}"
        ((pass_count++))
    else
        echo -e "${RED}✗ $module 不存在${NC}"
        ((fail_count++))
    fi
done

echo ""
echo "5. 编译检查"
echo "-----------------------------------"

echo -n "尝试编译项目... "
if mvn clean compile -DskipTests > /tmp/mvn-compile.log 2>&1; then
    echo -e "${GREEN}✓ 编译成功${NC}"
    ((pass_count++))
else
    echo -e "${RED}✗ 编译失败${NC}"
    echo -e "  提示: 查看 /tmp/mvn-compile.log 获取详细信息"
    echo -e "  最后一行错误:"
    tail -n 5 /tmp/mvn-compile.log | grep -E "(ERROR|BUILD FAILURE)" | head -n 3
    ((fail_count++))
fi

echo ""
echo "======================================"
echo -e "检查结果: ${GREEN}$pass_count${NC} 通过, ${RED}$fail_count${NC} 失败"
echo "======================================"
echo ""

if [ $fail_count -eq 0 ]; then
    echo -e "${GREEN}所有检查通过！可以开始启动项目。${NC}"
    echo ""
    echo "下一步："
    echo "1. 启动 Nacos: cd nacos/bin && ./startup.sh -m standalone"
    echo "2. 初始化数据库: mysql -u root -p < sql/init.sql"
    echo "3. 启动 Redis: redis-server"
    echo "4. 启动项目: ./start.sh"
else
    echo -e "${RED}存在 $fail_count 个问题，请修复后再启动项目。${NC}"
    echo ""
    echo "常见问题解决方案："
    echo "- Java 版本问题: 下载并安装 JDK 17+"
    echo "- MySQL 连接问题: 检查 MySQL 是否启动，密码是否正确"
    echo "- Redis 连接问题: 运行 redis-server"
    echo "- Nacos 连接问题: 启动 Nacos 并访问 http://localhost:8848/nacos"
    echo "- 编译失败: 查看日志 /tmp/mvn-compile.log"
    echo ""
    echo "详细帮助请查看: STARTUP_GUIDE.md 和 DIAGNOSE.md"
fi

echo ""
