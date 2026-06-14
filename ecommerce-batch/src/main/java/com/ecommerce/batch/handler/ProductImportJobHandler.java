package com.ecommerce.batch.handler;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ecommerce.batch.entity.Product;
import com.ecommerce.batch.mapper.ProductMapper;
import com.xxl.job.core.context.XxlJobHelper;
import com.xxl.job.core.handler.annotation.XxlJob;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

/**
 * 商品信息导入Job Handler
 * <p>
 * 通过txt文本导入商品信息，支持分片并行处理，文本格式说明：
 * - 文件编码：UTF-8
 * - 分隔符：|+|（竖线加号竖线）
 * - 每行一条商品记录
 * - 字段顺序：商品名称|+|商品描述|+|价格|+|库存数量|+|商品图片URL|+|状态|+|分类ID
 * <p>
 * 示例：
 * iPhone 15|+|苹果最新手机|+|7999.00|+|100|+|https://img.example.com/iphone15.jpg|+|1|+|1
 * <p>
 * 分片说明：
 * - 在xxl-job管理台将路由策略选择"分片广播"，可启动多个执行器实例并行处理
 * - 每个分片（执行器实例）只处理 行号 % 分片总数 == 分片序号 的数据行
 * - 分片参数由xxl-job调度中心自动下发，无需手动配置
 */
@Slf4j
@Component
public class ProductImportJobHandler extends ServiceImpl<ProductMapper, Product> {

    /**
     * txt文本字段分隔符
     */
    private static final String FIELD_SEPARATOR = "\\|\\+\\|";

    /**
     * 商品字段数量（不含自动生成的id和BaseEntity字段）
     */
    private static final int FIELD_COUNT = 7;

    /**
     * 批量插入的批次大小
     */
    private static final int BATCH_SIZE = 500;

    /**
     * 商品信息导入任务（支持分片广播）
     * <p>
     * 在xxl-job管理台配置：
     * - JobHandler名称：productImportJob
     * - 路由策略：分片广播
     * - 任务参数：txt文件路径，例如 /data/import/products.txt
     * <p>
     * 多实例部署时，每个实例自动处理属于自己的那部分数据行，
     * 通过 行号 % 分片总数 == 分片序号 进行数据分片
     */
    @XxlJob("productImportJob")
    public void productImportJob() {
        // 获取分片参数：分片序号(从0开始)、分片总数
        int shardIndex = XxlJobHelper.getShardIndex();
        int shardTotal = XxlJobHelper.getShardTotal();
        log.info("分片参数：当前分片序号={}, 分片总数={}", shardIndex, shardTotal);

        // 从xxl-job参数中获取文件路径
        String filePath = XxlJobHelper.getJobParam();
        if (filePath == null || filePath.trim().isEmpty()) {
            XxlJobHelper.handleFail("文件路径参数不能为空，请在任务参数中指定txt文件路径");
            return;
        }

        filePath = filePath.trim();
        log.info("分片[{}]开始导入商品信息，文件路径：{}", shardIndex, filePath);

        List<Product> productList = new ArrayList<>();
        int totalLines = 0;
        int skippedLines = 0;
        int successCount = 0;
        int failCount = 0;
        int batchIndex = 0;

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(new FileInputStream(filePath), StandardCharsets.UTF_8))) {
            String line;
            int lineNum = 0;

            while ((line = reader.readLine()) != null) {
                lineNum++;
                // 跳过空行和注释行（以#开头）
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#")) {
                    continue;
                }

                // 分片过滤：当前行是否由本分片处理
                // 当 shardTotal > 1 时，按行号取模分配；当 shardTotal == 1 时（单实例），处理所有行
                if (shardTotal > 1 && lineNum % shardTotal != shardIndex) {
                    skippedLines++;
                    continue;
                }

                totalLines++;

                try {
                    Product product = parseLine(line, lineNum);
                    productList.add(product);

                    // 达到批次大小则批量插入
                    if (productList.size() >= BATCH_SIZE) {
                        batchIndex++;
                        saveBatchTransactional(productList);
                        successCount += productList.size();
                        log.info("分片[{}]第{}批商品数据入库完成，本批数量：{}", shardIndex, batchIndex, productList.size());
                        productList.clear();
                    }
                } catch (Exception e) {
                    failCount++;
                    log.error("分片[{}]第{}行数据解析失败：{}，错误：{}", shardIndex, lineNum, line, e.getMessage());
                }
            }

            // 处理剩余数据
            if (!productList.isEmpty()) {
                batchIndex++;
                saveBatchTransactional(productList);
                successCount += productList.size();
                log.info("分片[{}]第{}批商品数据入库完成，本批数量：{}", shardIndex, batchIndex, productList.size());
            }
        } catch (Exception e) {
            log.error("分片[{}]商品导入异常：", shardIndex, e);
            XxlJobHelper.handleFail(String.format("分片[%d]商品导入异常：%s", shardIndex, e.getMessage()));
            return;
        }

        String result = String.format("分片[%d]导入完成！处理行数：%d，跳过行数：%d，成功：%d，失败：%d",
                shardIndex, totalLines, skippedLines, successCount, failCount);
        log.info(result);

        if (failCount > 0) {
            XxlJobHelper.handleFail(result + "，存在失败记录，请查看日志");
        } else {
            XxlJobHelper.handleSuccess(result);
        }
    }

    /**
     * 批量保存（独立事务，避免整个Job共享一个长事务）
     */
    @Transactional(rollbackFor = Exception.class)
    public void saveBatchTransactional(List<Product> productList) {
        this.saveBatch(productList);
    }

    /**
     * 解析单行文本为商品实体
     * 字段顺序：商品名称|+|商品描述|+|价格|+|库存数量|+|商品图片URL|+|状态|+|分类ID
     */
    private Product parseLine(String line, int lineNum) {
        String[] fields = line.split(FIELD_SEPARATOR, -1);
        if (fields.length != FIELD_COUNT) {
            throw new IllegalArgumentException(
                    String.format("第%d行字段数量不正确，期望%d个，实际%d个", lineNum, FIELD_COUNT, fields.length));
        }

        Product product = new Product();

        // 商品名称
        String name = fields[0].trim();
        if (name.isEmpty()) {
            throw new IllegalArgumentException(String.format("第%d行商品名称不能为空", lineNum));
        }
        product.setName(name);

        // 商品描述
        product.setDescription(fields[1].trim());

        // 价格
        try {
            product.setPrice(new BigDecimal(fields[2].trim()));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(String.format("第%d行价格格式错误：%s", lineNum, fields[2]));
        }

        // 库存数量
        try {
            product.setStock(Integer.parseInt(fields[3].trim()));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(String.format("第%d行库存数量格式错误：%s", lineNum, fields[3]));
        }

        // 商品图片URL
        product.setImageUrl(fields[4].trim());

        // 状态（0：下架，1：上架）
        try {
            product.setStatus(Integer.parseInt(fields[5].trim()));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(String.format("第%d行状态格式错误：%s", lineNum, fields[5]));
        }

        // 分类ID
        try {
            product.setCategoryId(Long.parseLong(fields[6].trim()));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(String.format("第%d行分类ID格式错误：%s", lineNum, fields[6]));
        }

        return product;
    }
}
