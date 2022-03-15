package com.zhuo.workbench.dao;

import com.zhuo.workbench.entity.Activity;

import java.util.List;
import java.util.Map;

/**
 * @作者：zhuojunyu
 * @时间：2022/2/25 - 16:12
 */
public interface ActivityDao {
    int save(Activity activity);

    int getTotalByCondition(Map<String, Object> map);

    List<Activity> getActivityListByCondition(Map<String, Object> map);

    int deleteById(String[] ids);

    Activity getActivityById(String id);

    boolean update(Activity activity);

    Activity detail(String id);

    List<Activity> getActivityListByClueId(String id);

    List<Activity> showActivityListByNameNotByClueId(Map<String, String> map);
}

