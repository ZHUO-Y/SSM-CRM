package com.zhuo.setting.service.impl;

import com.zhuo.setting.dao.UserDao;
import com.zhuo.setting.entity.User;
import com.zhuo.setting.exception.LoginException;
import com.zhuo.setting.service.UserService;
import com.zhuo.utils.DateTimeUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @作者：zhuojunyu
 * @时间：2022/2/23 - 17:59
 */
@Service(value = "userService")
public class UserServiceImpl implements UserService {

    //Service中调用Dao接口访问数据库。
    @Resource
    private UserDao dao;
    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        //这里进入验证登录信息流程。
        System.out.println("验证登录信息");
        Map<String,String> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User us = dao.login(map);
        if (us == null) {
            throw new LoginException("账号密码错误！");
        }
        //验证失效时间.
        String expireTime = us.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if (expireTime.compareTo(currentTime) < 0){
            throw new LoginException("账号已经失效。");
        }

        //验证账号锁定 0为锁，1为开
        String lc = us.getLockState();
        if("0".equals(lc)){
            throw new LoginException("账号被锁定。");
        }

        //判断ip地址。
        String allowIps = us.getAllowIps();
        if(!allowIps.contains(ip)){
            throw new LoginException("ip访问受限。");
        }

        return us;
    }

    @Override
    public List<User> getUserList() {
        System.out.println("开始得到用户集合服务");
        return dao.getUserList();
    }
}
