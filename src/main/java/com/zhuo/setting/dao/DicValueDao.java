package com.zhuo.setting.dao;

import com.zhuo.setting.entity.DicValue;

import java.util.List;

/**
 * @作者：zhuojunyu
 * @时间：2022/3/6 - 14:32
 */


public interface DicValueDao {
    List<DicValue> getDicValueByCode(String code);
}
