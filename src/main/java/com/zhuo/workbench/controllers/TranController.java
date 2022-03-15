package com.zhuo.workbench.controllers;

import com.zhuo.setting.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;

/**
 * @作者：zhuojunyu
 * @时间：2022/3/5 - 16:57
 */
@Controller
@RequestMapping("/workbench/Tran")
public class TranController {

    @Resource
    UserService userService;


}
