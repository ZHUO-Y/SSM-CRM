package com.zhuo.workbench.service;

import com.zhuo.vo.PaginationVo;
import com.zhuo.workbench.entity.Activity;
import com.zhuo.workbench.entity.ActivityRemark;

import java.util.List;
import java.util.Map;

/**
 * @作者：zhuojunyu
 * @时间：2022/2/25 - 16:19
 */
public interface ActivityService {
    boolean save(Activity activity);

    PaginationVo<Activity> pageList(Map<String,Object> map);

    boolean deleteByIds(String[] ids);

    Activity getActivityById(String id);

    boolean update(Activity activity);

    Activity detail(String id);

    List<ActivityRemark> getRemarkListByAid(String id);

    boolean saveRemark(ActivityRemark activityRemark);

    boolean updateRemark(ActivityRemark activityRemark);

    boolean deleteRemark(String id);

    List<Activity> getActivityListByClueId(String id);

    List<Activity> showActivityListByNameNotByClueId(String clueId, String name);
}
