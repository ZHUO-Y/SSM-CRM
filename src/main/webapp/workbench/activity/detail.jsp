<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>"/>
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css"
          rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $(".remarkDiv").mouseover(function () {
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").mouseout(function () {
                $(this).children("div").children("div").hide();
            });

            $(".myHref").mouseover(function () {
                $(this).children("span").css("color", "red");
            });

            $(".myHref").mouseout(function () {
                $(this).children("span").css("color", "#E6E6E6");
            });
            //页面加载完毕，展现备注列表
            showRemarkList();

            $("#remarkBody").on("mouseover",".remarkDiv",function(){
                $(this).children("div").children("div").show();
            })
            $("#remarkBody").on("mouseout",".remarkDiv",function(){
                $(this).children("div").children("div").hide();
            })
            
            //绑定编辑按钮
            $("#editBtn").click(edit);
            //绑定删除按钮
            $("#deleteBtn").click(deleteActivity);
            //绑定更新按钮
            $("#updataBtn").click(update);
            //绑定保存按钮
            $("#saveRemarkBtn").click(saveRemark);
            //绑定更新备注按钮
            $("#updateRemarkBtn").click(updateRemark)
        });
        //点击编辑按钮事件
        function edit() {
            $.ajax({
                url: "workbench/activity/getUserList.do",
                data: {},
                type: "get",
                dataType: "json",
                async: false,
                success: function (data) {
                    /*
                        data
                        [{"id":?,"name":?,"loginAct":?.......},{2},{3}...]
                    */
                    // alert("111");
                    var html = "";
                    //data是集合，n是对象。
                    $.each(data, function (i, n) {
                        /*<option>zhangsan</option>*/
                        html += "<option value = '" + n.id + "'>" + n.name +
                            "</option>";
                    })
                    //将html加入下拉列表组件。
                    $("#edit-owner").html(html);
                    //将下拉列表的默认设置为当前用户。
                    var id = "${user.id}";
                    $("#edit-owner").val(id);
                }
            })
            $("#editActivityModal").modal("show");
        }
        //点击删除按钮事件
        function deleteActivity() {
            if(confirm("确定删除这条记录吗？")){
                $.ajax({
                    url: "workbench/activity/deleteChecked.do",
                    data: "id=${a.id}",
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        //返回一个success就行了，一个boolean类型。
                        if (data) {
                            //删除成功，返回市场活动页面。
                            window.history.back();
                            alert("删除成功！");
                        } else {
                            alert("删除市场活动失败");
                        }
                    }
                })

            };

        }
        //点击更新按钮事件
        function update() {
            $.ajax({
                url: "workbench/activity/update.do",
                data: {
                    "id": $.trim($("#edit-id").val()),
                    "owner": $.trim($("#edit-owner").val()),
                    "name": $.trim($("#edit-name").val()),
                    "startDate": $.trim($("#edit-startDate").val()),
                    "endDate": $.trim($("#edit-endDate").val()),
                    "cost": $.trim($("#edit-cost").val()),
                    "description": $.trim($("#edit-description").val())
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    /*
                        data    需要传入id，才知道要修改哪一条记录。还需要传入修改的参数，总之传入一个activity
                        返回一个boolean类型即可。
                        {true/false}
                     */
                    if (data) {
                        location.reload();
                        //成功
                        alert("修改成功！");
                        //隐藏

                    } else {
                        alert("修改市场活动失败。");
                    }
                },
                error: function () {
                    alert("服务器处理请求发生错误。")
                }
            })
        }
        //刷新备注列表事件
        function showRemarkList() {
            //调ajax,得到备注信息列表。
            $.ajax({
                url : "workbench/activity/getRemarkListByAid.do",
                data : {
                    "id" : "${a.id}"
                },
                type : "get",
                dataType : "json",
                success : function (data) {
                    //传入市场活动的id,得到List<ActivityRemark> ar
                    var html = "";
                    $.each(data,function (i,n) {
                        /*
						javascript:void(0);
							将超链接禁用，只能以触发事件的形式来操作
					    */
                        html += '<div class="remarkDiv" style="height: 60px;">'
                        html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
                        html += '<div style="position: relative; top: -40px; left: 40px;">'
                        html += '<h5 id="e'+n.id+'">'+n.noteContent+'</h5>'
                        html +=
                            '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${a.name}</b> <small style="color: gray;">'+(n.editFlag==0?n.createTime:n.editTime)+' 由 '+(n.editFlag==0?n.createBy:n.editBy)+'</small>'
                        html +=
                            '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
                        html +=
                            '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+n.id+'\',\''+n.noteContent+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>'
                        html += "&nbsp;&nbsp;&nbsp;&nbsp;"
                        html +=
                            '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+ n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>'
                        html += '</div>'
                        html += '</div>'
                        html += '</div>'
                    })
                    //$("#remarkDiv").before(html);
                    $("#remarkHead").after(html);//可以。
                }
            })
        }
        //点击保存备注按钮
        function saveRemark() {
            if($("#remark").val()==""){
                alert("不能为空!")
                return;
            }
            $.ajax({
                url : "workbench/activity/saveRemark.do",
                data : {
                    "noteContent" : $.trim($("#remark").val()),
                    "activityId" : "${a.id}"
                },
                type : "post",
                dataType : "json",
                success : function (data) {

                    if(data){
                        //textarea文本域中的信息清空掉
                        $("#remark").val("");
                        $(".remarkDiv").remove();
                        showRemarkList();
                    }else {
                        alert("添加备注失败");
                    }

                }
            })
        }
        //点击编辑按钮
        function editRemark(id,noteContent) {
            //传入id的目的是，存入隐藏域中，等到需要走后台的时候，需要传入id值找到对应要修改的备注。
            $("#remarkId").val(id);
            //打开编辑窗口前,把备注信息放在文本域里，这个noteContent也可通过id取，需要去div里找到文本域所属性赋id值。
            $("#noteContent").val(noteContent);
            $("#editRemarkModal").modal("show");
        }
        //点击删除备注按钮
        function deleteRemark(id) {
            if(confirm("确定删除这条备注吗？")){
                $.ajax({
                    url : "workbench/activity/deleteRemark.do",
                    data : {
                        "id" : id
                    },
                    type : "post",
                    dataType : "json",
                    success : function (data) {
                        if(data){
                            //重载备注列表
                            $(".remarkDiv").remove();
                            showRemarkList();
                        }else {
                            alert("删除失败。")
                        }
                    }
                })
            }
        }
        //点击更新备注按钮
        function updateRemark() {
            var id = $("#remarkId").val();
            $.ajax({
                url : "workbench/activity/updateRemark.do",
                data : {
                    "id" : id,
                    "noteContent" : $("#noteContent").val()
                },
                type : "post",
                dataType : "json",
                success : function (data) {
                /*
                    data
                        {"success":true/false}
                 */
                    if(data){
                        $(".remarkDiv").remove();
                        showRemarkList();
                        $("#editRemarkModal").modal("hide");
                    }else {
                        alert("修改备注失败!");
                    }
                }
            })
        }
        
    </script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改备注</h4>
            </div>
            <div class="modal-body">
                <%--隐藏作用域--%>
                <input type="hidden" id="remarkId">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-description"
                               class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3"
                                      id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id" value="${a.id}">

                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">

                            </select>
                        </div>
                        <label for="edit-name"
                               class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control"
                                   id="edit-name" value="${a.name}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startDate"
                               class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-startDate"
                                   value="${a.startDate}">
                        </div>
                        <label for="edit-endDate"
                               class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-endDate"
                                   value="${a.endDate}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost"
                                   value="${a.cost}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description"
                               class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3"
                                      id="edit-description">${a.description}</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" data-dismiss="modal"
                        id="updataBtn">更新
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span
            class="glyphicon glyphicon-arrow-left"
            style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>市场活动-${a.name} <small>${a.startDate} ~ ${a.endDate}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" id="editBtn"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger" id="deleteBtn"><span
                class="glyphicon glyphicon-minus"></span> 删除
        </button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top:
			-20px;"><b>${a.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">
            名称
        </div>
        <div style="width: 300px;position: relative; left: 650px; top:
			-60px;"><b>${a.name}
        </b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">开始日期</div>
        <div style="width: 300px;position: relative; left: 200px; top:
			-20px;"><b>${a.startDate}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">
            结束日期
        </div>
        <div style="width: 300px;position: relative; left: 650px; top:
			-60px;"><b>${a.endDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">成本</div>
        <div style="width: 300px;position: relative; left: 200px; top:
			-20px;"><b>${a.cost}
        </b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top:
			-20px;"><b>${a.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${a.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top:
			-20px;"><b>${a.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${a.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${a.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
    <div class="page-header" id="remarkHead">
        <h4>备注</h4>
    </div>

    <!-- 备注1 -->
    <%--<div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png"
             style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;">
            <h5>哎呦！</h5>
            <font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small
                style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span
                        class="glyphicon glyphicon-edit"
                        style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span
                        class="glyphicon glyphicon-remove"
                        style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>

    <!-- 备注2 -->
    <div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png"
             style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;">
            <h5>呵呵！</h5>
            <font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small
                style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span
                        class="glyphicon glyphicon-edit"
                        style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span
                        class="glyphicon glyphicon-remove"
                        style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>--%>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control"
                      style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn"
               style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>