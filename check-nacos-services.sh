#!/bin/bash

echo "======================================"
echo "检查Nacos服务注册情况"
echo "======================================"

NACOS_URL="http://localhost:8848/nacos"

echo ""
echo "1. 检查ecommerce-user服务注册..."
curl -s "${NACOS_URL}/v1/ns/instance/list?serviceName=ecommerce-user" | python3 -m json.tool 2>/dev/null || curl -s "${NACOS_URL}/v1/ns/instance/list?serviceName=ecommerce-user"

echo ""
echo "2. 检查ecommerce-product服务注册..."
curl -s "${NACOS_URL}/v1/ns/instance/list?serviceName=ecommerce-product" | python3 -m json.tool 2>/dev/null || curl -s "${NACOS_URL}/v1/ns/instance/list?serviceName=ecommerce-product"

echo ""
echo "3. 检查ecommerce-gateway服务注册..."
curl -s "${NACOS_URL}/v1/ns/instance/list?serviceName=ecommerce-gateway" | python3 -m json.tool 2>/dev/null || curl -s "${NACOS_URL}/v1/ns/instance/list?serviceName=ecommerce-gateway"

echo ""
echo "4. 列出所有已注册的服务..."
curl -s "${NACOS_URL}/v1/ns/service/list?pageNo=1&pageSize=20&namespaceId=" | python3 -m json.tool 2>/dev/null || curl -s "${NACOS_URL}/v1/ns/service/list?pageNo=1&pageSize=20&namespaceId="

echo ""
echo "======================================"
echo "检查完成"
echo "======================================"
