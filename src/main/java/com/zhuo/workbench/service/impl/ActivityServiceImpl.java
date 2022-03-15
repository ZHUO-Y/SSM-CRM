package com.zhuo.workbench.service.impl;

import com.alibaba.druid.support.json.JSONUtils;
import com.zhuo.vo.PaginationVo;
import com.zhuo.workbench.dao.ActivityDao;
import com.zhuo.workbench.dao.ActivityRemarkDao;
import com.zhuo.workbench.dao.ClueActivityRelationDao;
import com.zhuo.workbench.entity.Activity;
import com.zhuo.workbench.entity.ActivityRemark;
import com.zhuo.workbench.entity.ClueActivityRelation;
import com.zhuo.workbench.service.ActivityService;
import org.omg.CORBA.ARG_IN;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @作者：zhuojunyu
 * @时间：2022/2/25 - 20:56
 */
@Service
public class ActivityServiceImpl implements ActivityService {

    @Resource
    ActivityDao activityDao;
    @Resource
    ActivityRemarkDao activityRemarkDao;
    @Resource
    ClueActivityRelationDao clueActivityRelationDao;

    @Override
    public boolean save(Activity activity) {
        System.out.println("进入保存市场活动服务");
        return activityDao.save(activity) == 1;
    }

    @Override
    public PaginationVo<Activity> pageList(Map<String, Object> map) {
        System.out.println("进入刷新市场活动服务");
        //取得total
        int total = activityDao.getTotalByCondition(map);
        //取得aList
        List<Activity> dataList = activityDao.getActivityListByCondition(map);
        //返回vo
        PaginationVo<Activity> paginationVo = new PaginationVo<>();
        paginationVo.setTotal(total);
        paginationVo.setDataList(dataList);
        return paginationVo;
    }

    @Override
    public boolean deleteByIds(String[] ids) {
        System.out.println("进入删除记录服务");
        //删除操作需要删除市场活动记录，和对应的备注信息。
        //先删除备注信息。
        //先查询备注的条数
        int remarkCount = activityRemarkDao.getCountById(ids);
        //再删除备注
        int deleteRemarkCount = activityRemarkDao.deleteById(ids);

        boolean flag = remarkCount == deleteRemarkCount;
        //在删除市场活动记录。
        int deleteActivityCount = activityDao.deleteById(ids);
        //如果为ture，与上flag，不改变结果；如果为false，与上flag，必为false。
        flag = deleteActivityCount == ids.length && flag;
        if(flag){
            System.out.println("删除成功!");
        }
        return flag;
    }

    @Override
    public Activity getActivityById(String id) {
        return activityDao.getActivityById(id);
    }

    @Override
    public boolean update(Activity activity) {
        return activityDao.update(activity);
    }

    @Override
    public Activity detail(String id) {
        return activityDao.detail(id);
    }

    @Override
    public List<ActivityRemark> getRemarkListByAid(String id) {
        return activityRemarkDao.getRemarkListByAid(id);
    }

    @Override
    public boolean saveRemark(ActivityRemark activityRemark) {
        return activityRemarkDao.saveRemark(activityRemark)==1;
    }

    @Override
    public boolean updateRemark(ActivityRemark activityRemark) {
        return activityRemarkDao.updateRemarkById(activityRemark) == 1;
    }

    @Override
    public boolean deleteRemark(String id) {
        return activityRemarkDao.deleteRemarkById(id) == 1;
    }

    @Override
    public List<Activity> getActivityListByClueId(String id) {
        return activityDao.getActivityListByClueId(id);
    }

    @Override
    public List<Activity> showActivityListByNameNotByClueId(String clueId, String name) {
        Map<String,String> map = new HashMap<>();
        map.put("clueId",clueId);
        map.put("name",name);
        return activityDao.showActivityListByNameNotByClueId(map);
    }


}
