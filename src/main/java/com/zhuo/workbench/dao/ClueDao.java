package com.zhuo.workbench.dao;

import com.zhuo.workbench.entity.Clue;

import java.util.List;
import java.util.Map;

/**
 * @作者：zhuojunyu
 * @时间：2022/3/6 - 19:29
 */
public interface ClueDao {
    int insertOne(Clue clue);

    int selectCountTotalByCondition(Map<String, Object> map);

    List<Clue> selectByCondition(Map<String, Object> map);

    Clue selectClueById(String id);
}
