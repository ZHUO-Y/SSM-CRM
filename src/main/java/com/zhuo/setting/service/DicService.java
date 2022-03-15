package com.zhuo.setting.service;

import com.zhuo.setting.entity.DicValue;

import java.util.List;
import java.util.Map;

/**
 * @作者：zhuojunyu
 * @时间：2022/3/6 - 14:27
 */
public interface DicService {
    Map<String, List<DicValue>> getAll();
}
