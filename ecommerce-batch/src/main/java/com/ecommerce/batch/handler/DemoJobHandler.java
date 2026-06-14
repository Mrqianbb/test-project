package com.ecommerce.batch.handler;

import com.xxl.job.core.context.XxlJobHelper;
import com.xxl.job.core.handler.annotation.XxlJob;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

/**
 * 示例Job Handler
 */
@Slf4j
@Component
public class DemoJobHandler {

    @XxlJob("demoJobHandler")
    public void demoJobHandler() {
        XxlJobHelper.log("XXL-JOB, demo job handler executed.");
    }
}
