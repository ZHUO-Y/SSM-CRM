package com.zhuo.vo;

import lombok.Data;

import java.util.List;

/**
 * @作者：zhuojunyu
 * @时间：2022/2/26 - 15:36
 */
@Data
public class PaginationVo<T> {
    private int total;
    private List<T> dataList;
}
