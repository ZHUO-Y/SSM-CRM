package com.zhuo.setting.entity;
import lombok.Data;
/**
 * @作者：zhuojunyu
 * @时间：2022/2/23 - 16:39
 */
@Data
public class User {
    private String id; // 编号 主键
    private String loginAct; // 登录账号
    private String name; // 用户的真实姓名
    private String loginPwd; // 登录密码
    private String email; // 邮箱
    private String expireTime; // 失效时间 19位
    private String lockState; // 锁定状态 0: 锁定  1: 启用
    private String deptno; // 部门编号
    private String allowIps; // 允许访问的ip地址
    private String createTime; // 创建时间 19位
    private String createBy; // 创建人
    private String editTime; // 修改时间 19位
    private String editBy; // 修改人
}
