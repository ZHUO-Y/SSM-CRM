package com.zhuo.setting.dao;

import com.zhuo.setting.entity.User;

import java.util.List;
import java.util.Map;

/**
 * @作者：zhuojunyu
 * @时间：2022/2/23 - 17:54
 */
public interface UserDao {
    User login(Map<String,String> map);

    List<User> getUserList();
}
