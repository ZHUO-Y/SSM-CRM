package com.zhuo.workbench.dao;

import com.zhuo.workbench.entity.ClueActivityRelation;

/**
 * @作者：zhuojunyu
 * @时间：2022/3/6 - 19:29
 */
public interface ClueActivityRelationDao {
    int unbund(String id);

    int bund(ClueActivityRelation car);
}
