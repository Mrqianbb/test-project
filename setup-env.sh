#!/bin/bash

# 快速环境准备脚本

echo "======================================"
echo "电商平台环境快速准备脚本"
echo "======================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查 Homebrew
if ! command -v brew &> /dev/null; then
    echo -e "${RED}错误: 未找到 Homebrew${NC}"
    echo "请先安装 Homebrew: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

echo -e "${GREEN}✓ Homebrew 已安装${NC}"

# 安装 JDK 17
echo ""
echo -e "${YELLOW}检查 JDK 17...${NC}"
if ! /usr/libexec/java_home -v 17 &> /dev/null; then
    echo "正在安装 JDK 17..."
    brew install openjdk@17
    
    # 设置 JAVA_HOME
    echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 17)' >> ~/.zshrc
    echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.zshrc
    
    echo -e "${GREEN}✓ JDK 17 安装完成${NC}"
    echo -e "${YELLOW}请运行: source ~/.zshrc${NC}"
else
    echo -e "${GREEN}✓ JDK 17 已安装${NC}"
fi

# 安装 Maven
echo ""
echo -e "${YELLOW}检查 Maven...${NC}"
if ! command -v mvn &> /dev/null; then
    echo "正在安装 Maven..."
    brew install maven
    echo -e "${GREEN}✓ Maven 安装完成${NC}"
else
    echo -e "${GREEN}✓ Maven 已安装${NC}"
fi

# 安装 MySQL
echo ""
echo -e "${YELLOW}检查 MySQL...${NC}"
if ! command -v mysql &> /dev/null; then
    echo "正在安装 MySQL..."
    brew install mysql
    brew services start mysql
    
    echo -e "${YELLOW}MySQL 正在启动，请稍候...${NC}"
    sleep 5
    
    echo -e "${GREEN}✓ MySQL 安装完成${NC}"
    echo -e "${YELLOW}MySQL root 密码为空，请运行: mysql_secure_installation 设置密码${NC}"
else
    echo -e "${GREEN}✓ MySQL 已安装${NC}"
    if ! brew services list | grep mysql | grep started &> /dev/null; then
        brew services start mysql
        echo -e "${GREEN}✓ MySQL 服务已启动${NC}"
    fi
fi

# 安装 Redis
echo ""
echo -e "${YELLOW}检查 Redis...${NC}"
if ! command -v redis-cli &> /dev/null; then
    echo "正在安装 Redis..."
    brew install redis
    brew services start redis
    echo -e "${GREEN}✓ Redis 安装完成${NC}"
else
    echo -e "${GREEN}✓ Redis 已安装${NC}"
    if ! brew services list | grep redis | grep started &> /dev/null; then
        brew services start redis
        echo -e "${GREEN}✓ Redis 服务已启动${NC}"
    fi
fi

# 检查 Nacos
echo ""
echo -e "${YELLOW}检查 Nacos...${NC}"
NACOS_HOME="$HOME/nacos"
if [ ! -d "$NACOS_HOME" ]; then
    echo "正在下载 Nacos..."
    NACOS_VERSION="2.2.3"
    cd /tmp
    curl -O https://github.com/alibaba/nacos/releases/download/${NACOS_VERSION}/nacos-server-${NACOS_VERSION}.tar.gz
    tar -xzf nacos-server-${NACOS_VERSION}.tar.gz
    mv nacos $NACOS_HOME
    
    echo -e "${GREEN}✓ Nacos 下载完成${NC}"
    echo -e "${YELLOW}启动 Nacos: cd $NACOS_HOME/bin && ./startup.sh -m standalone${NC}"
else
    echo -e "${GREEN}✓ Nacos 已下载${NC}"
    if ! curl -s http://localhost:8848/nacos &> /dev/null; then
        echo -e "${YELLOW}Nacos 未运行，启动命令: cd $NACOS_HOME/bin && ./startup.sh -m standalone${NC}"
    else
        echo -e "${GREEN}✓ Nacos 正在运行${NC}"
    fi
fi

echo ""
echo "======================================"
echo -e "${GREEN}环境准备完成！${NC}"
echo "======================================"
echo ""
echo "下一步操作："
echo "1. 加载环境变量: source ~/.zshrc"
echo "2. 初始化数据库: mysql -u root < sql/init.sql"
echo "3. 启动 Nacos: cd ~/nacos/bin && ./startup.sh -m standalone"
echo "4. 检查环境: ./check-env.sh"
echo "5. 启动项目: ./start.sh"
echo ""
