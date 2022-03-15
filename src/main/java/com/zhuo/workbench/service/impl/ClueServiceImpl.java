package com.zhuo.workbench.service.impl;

import com.zhuo.utils.UUIDUtil;
import com.zhuo.vo.PaginationVo;
import com.zhuo.workbench.dao.ClueActivityRelationDao;
import com.zhuo.workbench.dao.ClueDao;
import com.zhuo.workbench.entity.Clue;
import com.zhuo.workbench.entity.ClueActivityRelation;
import com.zhuo.workbench.service.ClueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @作者：zhuojunyu
 * @时间：2022/3/6 - 16:32
 */
@Service("clueService")
public class ClueServiceImpl implements ClueService {

    @Resource
    private ClueDao clueDao;

    @Resource
    private ClueActivityRelationDao clueActivityRelationDao;

    @Override
    public boolean save(Clue clue) {
        return clueDao.insertOne(clue) == 1;
    }

    @Override
    public PaginationVo<Clue> pageList(Map<String, Object> map) {
        System.out.println("进入刷新线索列表的服务");
        PaginationVo vo = new PaginationVo();
        //总条数
        int total = clueDao.selectCountTotalByCondition(map);
        System.out.println("计算总条数！");
        System.out.println("总条数是：" + total);
        //线索列表
        System.out.println("得到线索列表");
        List<Clue> cList = clueDao.selectByCondition(map);
        vo.setDataList(cList);
        vo.setTotal(total);

        return vo;
    }

    @Override
    public Clue selectClueById(String id) {
        System.out.println("进入查找单条线索信息服务器。");
        return clueDao.selectClueById(id);
    }

    @Override
    public boolean unbund(String id) {
        return clueActivityRelationDao.unbund(id) == 1;
    }

    @Override
    public boolean bund(String clueId, String[] activityIds) {
        for (String activityId : activityIds) {
            ClueActivityRelation car = new ClueActivityRelation();
            car.setActivityId(activityId);
            car.setClueId(clueId);
            car.setId(UUIDUtil.getUUID());
            if (clueActivityRelationDao.bund(car)!=1) {
                return false;
            }
        }
        return true;
    }


}
