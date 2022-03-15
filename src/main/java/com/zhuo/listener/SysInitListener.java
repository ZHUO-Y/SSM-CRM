package com.zhuo.listener;

import com.zhuo.setting.entity.DicValue;
import com.zhuo.setting.service.DicService;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @作者：zhuojunyu
 * @时间：2022/3/6 - 14:43
 */
public class SysInitListener implements ServletContextListener {

    /*  @Resource
        private DicService dicService;  注入失败！  */
    /*
        Listener的生命周期和spring管理的bean的生命周期。

        (1)Listener的生命周期是由servlet容器（例如tomcat）管理的，项目启动时上例中的ConfigListener是由servlet
        容器实例化并调用其contextInitialized方法，而servlet容器并不认得@Autowired注解，
        因此导致ConfigService实例注入失败。

        (2)而spring容器中的bean的生命周期是由spring容器管理的。

        4.那么该如何在spring容器外面获取到spring容器bean实例的引用呢？
        这就需要用到spring为我们提供的WebApplicationContextUtils

* 工具类，该工具类的作用是获取到spring容器的引用，进而获取到我们需要的bean实例。*/
    /*
     * 该方法是用来监听上下文域对象的方法,当服务器启动,上下文域对象创建
     * 对象创建完毕后,马上执行该方法
     *
     * event: 该参数能够取得监听的对象
     *      监听的是什么对象,就可以通过该参数取得什么对象
     *      例如我们现在监听的是上下文域对象,通过该参数就可以取得上下文域对象
     */
    @Override
    public void contextInitialized(ServletContextEvent event) {
        // System.out.println("上下文域对象创建了");
        System.out.println("服务器缓存处理数据字典开始");
        //拿到application
        ServletContext application = event.getServletContext();
        //调用dic服务层,容器外注入bean对象注入
        //WebApplicationContextUtils.getWebApplicationContext(event.getServletContext());
        //上面这个方法也可得到Spring单例的Context,只是返回null,不会报出异常，可能导致空指针异常。
        DicService dicService =
                WebApplicationContextUtils.getRequiredWebApplicationContext(event.getServletContext()).getBean(DicService.class);
        /*
            应该管业务层要
            7个list

            可以打包成为一个map
            业务层应该是这样来保存数据的：
                map.put("appellationList",dvList1);
                map.put("clueStateList",dvList2);
                map.put("stageList",dvList3);
                ....
         */
        Map<String,List<DicValue>> map = dicService.getAll();
        //循环这个map，放入application
        map.forEach(application::setAttribute);
        System.out.println("服务器缓存处理数据字典结束");

    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {

    }
}
