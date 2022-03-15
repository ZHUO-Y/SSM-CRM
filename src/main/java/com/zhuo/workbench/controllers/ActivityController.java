package com.zhuo.workbench.controllers;

import com.zhuo.setting.entity.User;
import com.zhuo.setting.service.UserService;
import com.zhuo.utils.DateTimeUtil;
import com.zhuo.utils.UUIDUtil;
import com.zhuo.vo.PaginationVo;
import com.zhuo.workbench.entity.Activity;
import com.zhuo.workbench.entity.ActivityRemark;
import com.zhuo.workbench.service.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @作者：zhuojunyu
 * @时间：2022/2/25 - 16:19
 */

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {

    @Resource
    private UserService userService;
    @Resource
    private ActivityService activityService;

    @RequestMapping("/getUserList.do")  //需要返回前端用户集合。用List
    @ResponseBody
    public List<User> login() {
        System.out.println("加入得到用户集合的控制器");

        List<User> uList = userService.getUserList();
//        System.out.println("用户集合"+uList);
        return uList;

    }

    @RequestMapping("/save.do")
    @ResponseBody
    public Map<String,Object> save(HttpSession session,Activity activity){
        System.out.println("进入保存市场活动控制器");
        Map<String,Object> map = new HashMap<>();
        //补充activity的属性。
        //id
        activity.setId(UUIDUtil.getUUID());
        //创建人
        User us = (User) session.getAttribute("user");
        activity.setCreateBy(us.getName());
        //创建时间
        activity.setCreateTime(DateTimeUtil.getSysTime());
        //修改人和修改时间空着。
        boolean success = activityService.save(activity);
        map.put("success",success);
        return map;
    }

    @RequestMapping("/pageList.do")
    @ResponseBody
    public PaginationVo<Activity> pageList(HttpServletRequest request){
        System.out.println("进入展示市场活动列表控制器");
        Map<String,Object> map = new HashMap<>();
        map.put("name",request.getParameter("name"));
        map.put("owner",request.getParameter("owner"));
        map.put("startDate",request.getParameter("startDate"));
        map.put("endDate",request.getParameter("endDate"));
        //每页展现的记录数和页数
        int pageSize = Integer.parseInt(request.getParameter("pageSize"));
        int pageNo = Integer.parseInt(request.getParameter("pageNo"));
        int skipCount = (pageNo-1)*pageSize;
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        return activityService.pageList(map);
    }

    @RequestMapping("/deleteChecked.do")
    @ResponseBody
    public boolean deleteChecked(HttpServletRequest request){
        System.out.println("进入删除记录控制器");
        String[] ids = request.getParameterValues("id");
        return activityService.deleteByIds(ids);
    }

    @RequestMapping("/getUserListAndActivity.do")
    @ResponseBody
    public Map<String,Object> getUserListAndActivity(String id){
        Map<String,Object> map = new HashMap<>();
        List<User> uList = userService.getUserList();
        Activity activity = activityService.getActivityById(id);
        map.put("uList",uList);
        map.put("activity",activity);
        return map;
    }

    @RequestMapping("/update.do")
    @ResponseBody
    public boolean update(HttpSession session,Activity activity){
        //这里需要添加两个属性，修改人和修改时间。修改人在session里。
        User us = (User) session.getAttribute("user");
        activity.setEditBy(us.getName());
        activity.setEditTime(DateTimeUtil.getSysTime());
        return activityService.update(activity);
    }

    //跳转到详细信息页，用传统请求
    @RequestMapping("/detail.do")
    public ModelAndView detail(String id){
        System.out.println("进入详细信息页控制器");
        ModelAndView mv = new ModelAndView();
        //需要传入前端，一个activity,备注另外发起ajax请求.
        Activity ac =  activityService.detail(id);
        mv.addObject("a",ac);
        mv.setViewName("/workbench/activity/detail");
        return mv;
    }

    @RequestMapping("/getRemarkListByAid.do")
    @ResponseBody
    public List<ActivityRemark> getRemarkListByAid(String id){
        System.out.println("进入刷新备注列表控制器");
        return activityService.getRemarkListByAid(id);
    }

    @RequestMapping("/saveRemark.do")
    @ResponseBody
    public boolean saveRemark(HttpSession session,String noteContent,String activityId){
        System.out.println("进入保存备注的控制器");
        ActivityRemark activityRemark = new ActivityRemark();
        User us = (User) session.getAttribute("user");
        activityRemark.setId(UUIDUtil.getUUID());
        activityRemark.setNoteContent(noteContent);
        activityRemark.setCreateBy(us.getName());
        activityRemark.setCreateTime(DateTimeUtil.getSysTime());
        activityRemark.setActivityId(activityId);
        activityRemark.setEditFlag("0");
        return activityService.saveRemark(activityRemark);
    }

    @RequestMapping("/updateRemark.do")
    @ResponseBody
    public boolean updateRemark(HttpSession session,String id,String noteContent){
        ActivityRemark activityRemark = new ActivityRemark();
        User user = (User) session.getAttribute("user");
        activityRemark.setId(id);
        activityRemark.setEditFlag("1");
        activityRemark.setEditBy(user.getName());
        activityRemark.setEditTime(DateTimeUtil.getSysTime());
        activityRemark.setNoteContent(noteContent);
        return activityService.updateRemark(activityRemark);
    }

    @RequestMapping("/deleteRemark.do")
    @ResponseBody
    public boolean deleteRemark(String id){
        return activityService.deleteRemark(id);
    }

}
