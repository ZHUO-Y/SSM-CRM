package com.zhuo.workbench.service;

import com.zhuo.vo.PaginationVo;
import com.zhuo.workbench.entity.Activity;
import com.zhuo.workbench.entity.Clue;

import java.util.Map;

/**
 * @作者：zhuojunyu
 * @时间：2022/3/6 - 16:31
 */
public interface ClueService {
    boolean save(Clue clue);

    PaginationVo<Clue> pageList(Map<String, Object> map);

    Clue selectClueById(String id);

    boolean unbund(String id);

    boolean bund(String clueId, String[] activityIds);
}
