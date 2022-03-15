package com.zhuo.setting.service.impl;

import com.zhuo.setting.dao.DicTypeDao;
import com.zhuo.setting.dao.DicValueDao;
import com.zhuo.setting.entity.DicType;
import com.zhuo.setting.entity.DicValue;
import com.zhuo.setting.service.DicService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @作者：zhuojunyu
 * @时间：2022/3/6 - 14:28
 */
@Service(value = "dicService")
public class DicServiceImpl implements DicService {

    @Resource
    private DicTypeDao dicTypeDao;

    @Resource
    private DicValueDao dicValueDao;

    @Override
    public Map<String, List<DicValue>> getAll() {
        //这里得到7个dicList<DicValue>,每个list装一种类型的value。
        //应该先循环得到typeList，然后通过type查所有这个type的DicValue。装成一个DicValueList。
        Map<String,List<DicValue>> dicValueMap = new HashMap<>();
        List<DicType> list = dicTypeDao.getAll();
        list.forEach(item->{
            System.out.println(item);
            List<DicValue> dicValueList = dicValueDao.getDicValueByCode(item.getCode());
            dicValueMap.put(item.getCode(),dicValueList);
        });
        return dicValueMap;
    }
}
