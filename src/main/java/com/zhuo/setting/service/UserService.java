package com.zhuo.setting.service;

import com.zhuo.setting.entity.User;
import com.zhuo.setting.exception.LoginException;

import java.util.List;

/**
 * @作者：zhuojunyu
 * @时间：2022/2/23 - 17:57
 */
public interface UserService {
    User login(String loginAct,String loginPwd,String ip) throws LoginException;

    List<User> getUserList();
}
