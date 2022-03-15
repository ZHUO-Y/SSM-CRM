package com.zhuo.workbench.entity;

import lombok.Data;

@Data
public class ActivityRemark {

    private String id;     //
    private String noteContent;    //备注信息。
    private String createTime;     //
    private String createBy;       //
    private String editTime;       //
    private String editBy;     //
    private String editFlag;       //
    private String activityId;     //
}
