package com.zhuo.workbench.dao;

import com.zhuo.workbench.entity.ActivityRemark;

import java.util.List;

/**
 * @作者：zhuojunyu
 * @时间：2022/2/25 - 16:13
 */
public interface ActivityRemarkDao {
    int getCountById(String[] ids);

    int deleteById(String[] ids);

    List<ActivityRemark> getRemarkListByAid(String id);

    int saveRemark(ActivityRemark activityRemark);

    int updateRemarkById(ActivityRemark activityRemark);

    int deleteRemarkById(String id);
}
