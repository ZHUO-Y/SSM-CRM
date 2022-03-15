package com.zhuo.workbench.entity;

import lombok.Data;

@Data
public class Activity {

    private String id;  //主键
    private String owner;   //UUID 所有者 外键
    private String name;    //市场活动名称
    private String startDate;   //开始日期 年月日 10位
    private String endDate; //结束日期 年月日 10位
    private String cost;    //成本
    private String description; //描述
    private String createTime;  //创建时间 年月日 时分秒
    private String createBy;    //创建人
    private String editTime;    //修改时间 年月日 时分秒
    private String editBy;  //修改人
}
