package com.zhuo.workbench.controllers;

import com.zhuo.setting.entity.User;
import com.zhuo.setting.service.UserService;
import com.zhuo.utils.DateTimeUtil;
import com.zhuo.utils.UUIDUtil;
import com.zhuo.vo.PaginationVo;
import com.zhuo.workbench.entity.Activity;
import com.zhuo.workbench.entity.Clue;
import com.zhuo.workbench.service.ActivityService;
import com.zhuo.workbench.service.ClueService;
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
 * @时间：2022/3/5 - 16:50
 */

@Controller
@RequestMapping("/workbench/clue")
public class ClueController {

    @Resource
    private UserService userService;

    @Resource
    private ClueService clueService;

    @Resource
    private ActivityService activityService;

    @RequestMapping("/getUserList.do")
    @ResponseBody
    public List<User> getUserList() {
        return userService.getUserList();
    }

    @RequestMapping("/save.do")
    @ResponseBody
    public boolean save(HttpSession session, Clue clue) {
        //id
        clue.setId(UUIDUtil.getUUID());
        //createBy
        User user = (User) session.getAttribute("user");
        clue.setCreateBy(user.getName());
        //createTime
        String createTime = DateTimeUtil.getSysTime();
        clue.setCreateTime(createTime);
        return clueService.save(clue);
    }

    @RequestMapping("/pageList.do")
    @ResponseBody
    public PaginationVo<Clue> pageList(HttpServletRequest request){
        //由于需要分页查询，需要用到跳过的条数skipCount和展示的条数showCount
        Map<String,Object> map = new HashMap<>();
        map.put("fullname",request.getParameter("fullname"));
        map.put("company",request.getParameter("company"));
        map.put("phone",request.getParameter("phone"));
        map.put("source",request.getParameter("source"));
        map.put("owner",request.getParameter("owner"));
        map.put("mphone",request.getParameter("mphone"));
        map.put("state",request.getParameter("state"));
        //前端给的每页展现的记录数和页数，需要计算出跳过的条数
        int pageSize = Integer.parseInt(request.getParameter("pageSize"));
        int pageNo = Integer.parseInt(request.getParameter("pageNo"));
        int skipCount = (pageNo-1)*pageSize;
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        //前端需要搜索到的线索列表和总条数。Vo已经封装好了。
        return clueService.pageList(map);
    }

    @RequestMapping("/detail.do")
    public ModelAndView detail(String id){
        ModelAndView mv = new ModelAndView();
        Clue c = clueService.selectClueById(id);
        mv.addObject("c",c);
        mv.setViewName("/workbench/clue/detail");
        return mv;
    }

    @RequestMapping("/getActivityListByClueId.do")
    @ResponseBody
    public List<Activity> getActivityListByClueId(String id){
        return activityService.getActivityListByClueId(id);
    }

    @RequestMapping("/unbund.do")
    @ResponseBody
    public boolean unbund(String id){
        return clueService.unbund(id);
    }

    @RequestMapping("/showActivityListByName.do")
    @ResponseBody
    public List<Activity> showActivityListByName(String clueId,String name){
        return activityService.showActivityListByNameNotByClueId(clueId,name);
    }

    @RequestMapping("/bund.do")
    @ResponseBody
    public boolean bund(HttpServletRequest request){
        String clueId = request.getParameter("clueId");
        String[] activityIds = request.getParameterValues("activityId");

        return clueService.bund(clueId,activityIds);
    }
}
