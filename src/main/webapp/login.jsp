<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>

<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css"
          rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script>
        $(function () {
            if (window.top != window) {
                window.top.location = window.location;
            }
            //页面加载完毕后，将用户文本框中的密码清空。
            $("#userPwd").val("")

            //页面加载完毕后，若用户名为空，用户名获得焦点。
            if ($("#userAct").val() === "") {
                $("#userAct").focus();
            } else {
                $("#userPwd").focus();
            }
            //alert($("#userAct").val() === "");

            //为当前登录也窗口绑定敲键盘事件
            //event:这个参数可以取得我们敲的是哪个键
            $(window).keydown(function (event) {
                //alert(event.keyCode);
                if (event.keyCode === 13) {
                    //alert("按下回车");
                    login();
                }
            })

            //为登录按钮绑定事件，执行登录操作。
            $("#loginBtn").click(function () {
                login();
            });

        })

        function login() {
            //alert("Login");
            //验证账号密码不能为空
            //取得账号密码
            //将文本中的左右空格去掉，使用$.trim(文本)
            var loginPwd = $("#userPwd").val().trim();
            var loginAct = $("#userAct").val().trim();
            //alert(loginAct + loginPwd);

            //去后台验证登录相关操作
            $.ajax({
                url: "settings/user/login.do",
                data: {
                    "loginAct": loginAct,
                    "loginPwd": loginPwd
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    /*
                        data
                            {"success":true/false,"msg":"哪错了"}
                     */
                    //如果登录成功
                    if (data.success) {
                        //跳转到工作台的初始也（欢迎页）
                        window.location.href = "workbench/index.jsp";
                        //如果登录失败
                    } else {
                        $("#msg").html(data.msg);
                    }
                }
            })
        }
    </script>
</head>

<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG"
         style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div
            style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2021&nbsp;Zhuo-Y</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="workbench/index.jsp" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" id="userAct" type="text"
                           placeholder="用户名" value="">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" id="userPwd" type="password"
                           placeholder="密码">
                </div>
                <div class="checkbox" style="position: relative;top: 30px; left: 10px;">

                    <span id="msg" style="color: red"></span>

                </div>
                <button type="button" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;"
                        id="loginBtn">登录
                </button>
            </div>
        </form>
    </div>
</div>
</body>

</html>