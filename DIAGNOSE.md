# 项目启动问题诊断指南

## 快速诊断清单

在报告问题之前，请按照以下步骤进行诊断：

### 1. 环境检查

```bash
# 检查 Java 版本
java -version
# 应该显示: openjdk version "17.x.x"

# 检查 Maven 版本
mvn -version
# 应该显示: Apache Maven 3.x.x

# 检查 MySQL 服务
mysql -u root -p -e "SELECT 1;"
# 应该显示: 1

# 检查 Redis 服务
redis-cli ping
# 应该显示: PONG

# 检查 Nacos 服务
curl http://localhost:8848/nacos
# 应该返回 Nacos 页面内容
```

### 2. 编译检查

```bash
# 清理并编译项目
mvn clean compile -DskipTests

# 如果编译失败，查看详细错误信息
mvn clean compile -X -DskipTests 2>&1 | tee compile.log
```

### 3. 单独测试每个服务

```bash
# 测试用户服务
cd ecommerce-user
mvn spring-boot:run

# 测试商品服务
cd ../ecommerce-product
mvn spring-boot:run

# 测试订单服务
cd ../ecommerce-order
mvn spring-boot:run

# 测试支付服务
cd ../ecommerce-payment
mvn spring-boot:run

# 测试网关服务
cd ../ecommerce-gateway
mvn spring-boot:run
```

## 常见错误及解决方案

### 错误 1: `java.lang.NoClassDefFoundError`

**症状**: 启动时报错找不到类

**可能原因**:
- 依赖缺失
- Maven 依赖未正确下载

**解决方案**:
```bash
# 清理 Maven 缓存并重新下载
rm -rf ~/.m2/repository/com/ecommerce
mvn clean install -U

# 检查依赖树
mvn dependency:tree
```

### 错误 2: `java.lang.ClassNotFoundException`

**症状**: 启动时报找不到特定类

**可能原因**:
- 类路径配置错误
- 包名错误

**解决方案**:
1. 检查启动类的 `@SpringBootApplication` 注解
2. 确保包扫描路径正确
3. 检查类名是否正确

```java
@SpringBootApplication
public class UserApplication {
    public static void main(String[] args) {
        SpringApplication.run(UserApplication.class, args);
    }
}
```

### 错误 3: `Failed to configure a DataSource`

**症状**: 数据库连接配置错误

**可能原因**:
- MySQL 未启动
- 数据库配置错误
- 数据库不存在

**解决方案**:
```yaml
# 检查 application.yml 配置
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/ecommerce?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
    username: root
    password: your_password

# 测试数据库连接
mysql -u root -p ecommerce
```

### 错误 4: `Unable to connect to Redis`

**症状**: Redis 连接失败

**可能原因**:
- Redis 未启动
- Redis 配置错误
- 端口被占用

**解决方案**:
```bash
# 检查 Redis 是否运行
redis-cli ping

# 检查 Redis 配置
spring:
  data:
    redis:
      host: localhost
      port: 6379

# 重启 Redis
redis-server --daemonize yes
```

### 错误 5: `Failed to connect to Nacos`

**症状**: Nacos 连接失败

**可能原因**:
- Nacos 未启动
- Nacos 地址配置错误
- 网络问题

**解决方案**:
```yaml
# 检查 Nacos 配置
spring:
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848

# 测试 Nacos 连接
curl http://localhost:8848/nacos

# 重启 Nacos
cd nacos/bin
./shutdown.sh
./startup.sh -m standalone
```

### 错误 6: `Port already in use`

**症状**: 端口被占用

**解决方案**:
```bash
# 查找占用端口的进程
lsof -i :8001  # 查找 8001 端口
lsof -i :9000  # 查找 9000 端口

# 停止占用端口的进程
kill -9 PID

# 或者修改服务端口号
server:
  port: 8001  # 修改为其他端口
```

### 错误 7: `BeanCreationException`

**症状**: Bean 创建失败

**可能原因**:
- 依赖注入错误
- 配置错误
- 循环依赖

**解决方案**:
1. 检查 `@Autowired` 或构造器注入
2. 检查 `@Service`、`@Component` 等注解
3. 查看详细的错误堆栈

```java
// 推荐使用构造器注入
@Service
@RequiredArgsConstructor
public class UserService {
    private final UserMapper userMapper;
    private final StringRedisTemplate redisTemplate;
}
```

### 错误 8: `No qualifying bean of type`

**症状**: 找不到对应的 Bean

**可能原因**:
- 接口未被实现
- 扫描路径错误
- 依赖缺失

**解决方案**:
```java
// 确保接口有实现类
@Mapper
public interface UserMapper extends BaseMapper<User> {
}

// 确保启动类有正确的注解
@SpringBootApplication
@MapperScan("com.ecommerce.user.mapper")
public class UserApplication {
    public static void main(String[] args) {
        SpringApplication.run(UserApplication.class, args);
    }
}
```

### 错误 9: `MyBatisPlusException`

**症状**: MyBatis Plus 配置错误

**解决方案**:
```yaml
# 检查 MyBatis Plus 配置
mybatis-plus:
  configuration:
    map-underscore-to-camel-case: true
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
  global-config:
    db-config:
      id-type: auto
      logic-delete-field: deleted
      logic-delete-value: 1
      logic-not-delete-value: 0
```

### 错误 10: `FeignClient.NotFoundException`

**症状**: Feign 客户端找不到服务

**可能原因**:
- 服务未注册到 Nacos
- 服务名错误
- Nacos 配置错误

**解决方案**:
```java
// 确保服务名正确
@FeignClient(name = "ecommerce-product")
public interface ProductFeignClient {
    // ...
}

// 检查服务是否注册到 Nacos
// 访问: http://localhost:8848/nacos
```

## 日志分析

### 查看启动日志

```bash
# 查看实时日志
tail -f logs/ecommerce-user.log

# 搜索错误日志
grep ERROR logs/ecommerce-user.log

# 搜索异常日志
grep -i exception logs/ecommerce-user.log
```

### 常见日志关键词

| 关键词 | 含义 | 可能原因 |
|--------|------|----------|
| `Connection refused` | 连接被拒绝 | 服务未启动、端口错误 |
| `Timeout` | 超时 | 网络问题、服务响应慢 |
| `Authentication failed` | 认证失败 | 密码错误、权限问题 |
| `No such file` | 文件不存在 | 配置文件路径错误 |
| `Bean creation error` | Bean 创建失败 | 依赖注入错误 |
| `ClassNotFoundException` | 类未找到 | 依赖缺失、包名错误 |

## 网络问题排查

### 检查端口是否开放

```bash
# 检查本地端口
netstat -an | grep 8848
netstat -an | grep 3306
netstat -an | grep 6379

# 检查服务是否监听
lsof -i :8848
lsof -i :3306
lsof -i :6379
```

### 测试网络连通性

```bash
# 测试 MySQL 连接
telnet localhost 3306

# 测试 Redis 连接
telnet localhost 6379

# 测试 Nacos 连接
curl -v http://localhost:8848/nacos
```

## 依赖问题排查

### 检查依赖冲突

```bash
# 查看依赖树
mvn dependency:tree

# 查看依赖分析
mvn dependency:analyze

# 查找特定依赖
mvn dependency:tree -Dincludes=mysql
```

### 清理本地仓库

```bash
# 清理本地 Maven 仓库中的特定依赖
rm -rf ~/.m2/repository/com/alibaba/cloud
rm -rf ~/.m2/repository/org/springframework/cloud

# 强制更新依赖
mvn clean install -U -DskipTests
```

## 配置验证

### 验证配置文件

```bash
# 检查配置文件语法
cat ecommerce-user/src/main/resources/application.yml | grep -A 5 "spring:"

# 检查配置文件编码
file ecommerce-user/src/main/resources/application.yml

# 检查配置文件权限
ls -la ecommerce-user/src/main/resources/application.yml
```

## 性能问题排查

### 检查内存使用

```bash
# 查看 JVM 内存
jps -l
jstat -gcutil <pid> 1000

# 堆转储
jmap -dump:format=b,file=heap.hprof <pid>
```

### 检查 CPU 使用

```bash
# 查看 Java 进程
ps aux | grep java

# 查看 CPU 使用
top -p <pid>
```

## 获取帮助

如果以上步骤都无法解决问题，请提供以下信息：

1. **错误信息**: 完整的错误堆栈
2. **环境信息**:
   - Java 版本
   - Maven 版本
   - 操作系统
   - MySQL 版本
   - Redis 版本
   - Nacos 版本
3. **配置信息**: 相关的配置文件内容
4. **日志信息**: 启动日志和错误日志
5. **重现步骤**: 如何复现问题

## 联系方式

- 查看项目文档: README.md, ARCHITECTURE.md, STARTUP_GUIDE.md
- 查看在线文档: [项目文档链接]
- 提交 Issue: [GitHub Issues]

---

**提示**: 大多数问题都可以通过检查配置和环境来解决。如果问题仍然存在，请确保按照 STARTUP_GUIDE.md 中的步骤正确配置和启动项目。
