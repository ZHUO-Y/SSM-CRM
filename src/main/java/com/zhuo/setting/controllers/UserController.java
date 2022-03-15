package com.zhuo.setting.controllers;

import com.zhuo.setting.entity.User;
import com.zhuo.setting.exception.LoginException;
import com.zhuo.setting.service.UserService;
import com.zhuo.utils.MD5Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * @作者：zhuojunyu
 * @时间：2022/2/23 - 17:46
 */
@Controller
@RequestMapping("/settings/user")
public class UserController {
    @Resource
    private UserService userService;

    @RequestMapping("/login.do")
    //需要返回前端两个信息。用map<String,String>
    @ResponseBody //因为是响应ajax，返回数据，所以＋这个。
    public Map<String,Object> login(String loginAct, String loginPwd,
                                    HttpServletRequest request) throws LoginException {
        Map<String,Object> map = new HashMap<>();
        String ip = request.getRemoteAddr();
        //拿到userService，调用login方法。
        System.out.println("进入到控制器中。"+loginAct+loginPwd+ip);
        //交给Service之前先加密。
        loginPwd = MD5Util.getMD5(loginPwd);
        //执行通过如果有返回值，则是成功了,如果登录失败，由handler捕捉。
        User user = userService.login(loginAct,loginPwd,ip);
        System.out.println(user);
        //把user放入Session中，登录以后还得用。
        request.getSession().setAttribute("user",user);
        map.put("success",true);
        System.out.println("登录成功！");
        return map;
    }

    //这里是对登录异常的处理器。写好了处理器，在Service里就可以抛出，由这个处理器捕捉并处理。
    @ResponseBody//这一行不加入会404.
    @ExceptionHandler(value = LoginException.class)
    public Map<String,Object> doLoginException(Exception e){
        Map<String,Object> map = new HashMap<>();
        String msg = e.getMessage();
        map.put("success",false);
        map.put("msg",msg);
        return map;
    }

}
