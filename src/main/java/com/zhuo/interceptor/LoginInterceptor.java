package com.zhuo.interceptor;

import com.zhuo.setting.entity.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * @作者：zhuojunyu
 * @时间：2022/2/25 - 14:07
 */
public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response,
                             Object handler) throws Exception {
        System.out.println("进入有没有登陆过的拦截器");
        String path = request.getServletPath();
        if("/login.jsp".equals(path) || "/settings/user/login.do".equals(path)){
            return true;
        }else {
            //必须验证有没有登录过。
            HttpSession session = request.getSession();
            User us = (User) session.getAttribute("user");
            //如果有us，则登陆过，如果没有，则没有登录过。
            if (us != null) {
                return true;
            }else {
                //重定向到登录页，为什么要重定向而不是请求转发，因为要让用户看到地址发生变化。
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return false;
            }
          /*重定向的路径怎么写？
            在实际项目开发中，对于路径的使用，不论操作的是前端还是后端，应该一律使用绝对路径
            关于转发和重定向的路径的写法如下：
            转发：
            使用的是一种特殊的绝对路径的使用方式，这种绝对路径前面不加/项目名，这种路径也称之为内部路径
                    /login.jsp
            重定向：
            使用的是传统绝对路径的写法，前面必须以/项目名开头，后面跟具体的资源路径
                    /crm/login.jsp*/
        }
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response,
                           Object handler, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }
}
