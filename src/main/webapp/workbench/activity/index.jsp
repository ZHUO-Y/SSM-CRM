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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css"
          type="text/css" rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <link rel="stylesheet" type="text/css"
          href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript"
            src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

    <script type="text/javascript">
        $(function () {
            //展现市场活动列表。
            pageList(1, 2);

            //绑定创建、编辑和删除按钮
            $("#addBtn").click(add);

            $("#editBtn").click(edit);

            $("#deleteBtn").click(deleteChecked);

            //绑定修改市场活动窗口的更新按钮
            $("#updateBtn").click(update);

            //绑定添加市场活动窗口中的保存按钮
            $("#saveBtn").click(save);

            //绑定上方工具条的查询按钮，用于条件查询市场活动
            $("#searchBtn").click(searchActivityList);

            //绑定市场活动列表中的全选复选框。
            $("#selectAll").click(changeAllSelect);

            //绑定复选框，因为动态生成的元素，是不能够以普通绑定事件的形式来进行操作的
            /*

                动态生成的元素，我们要以on方法的形式来触发事件
                语法：
                    $(需要绑定元素的有效的外层元素).on(绑定事件的方式,需要绑定的元素的jquery对象,回调函数)
             */
            $("#activityBody").on("click", $(":checkbox[name=selectOne]"), changeSelect);
        });
        //更新市场活动记录（这里的updata打错了，写成了update。）
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
                        //成功
                        alert("修改成功！");
                        //刷新市场活动信息列表（局部刷新）
                        pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                            , $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                        //隐藏
                        $("#editActivityModal").modal("hide");
                    } else {
                        alert("修改市场活动失败。");
                    }
                },
                error: function () {
                    alert("服务器处理请求发生错误。")
                }
            })
        }

        //删除市场活动
        function deleteChecked() {
            //找到选中的复选框的对象
            var $checkedOnes = $(":checked[name=selectOne]");
            //如果没选，就提示。
            if ($checkedOnes.length == 0) {
                alert("请选择你要删除的记录");
            } else {
                //先提醒是否删除
                if (confirm("确定删除选中的记录吗?")) {

                    //url:"workbench/activity/deleteChecked.do"
                    //需要传入市场活动的id，是一个数组，所以需要拼接字符串。
                    let param = "";
                    for (let i = 0; i < $checkedOnes.length; i++) {
                        param += "id=" + $checkedOnes[i].value;
                        if (i < $checkedOnes.length - 1) {
                            param += "&";
                        }
                    }
                    $.ajax({
                        url: "workbench/activity/deleteChecked.do",
                        data: param,
                        type: "post",
                        dataType: "json",
                        success: function (data) {
                            //返回一个success就行了，一个boolean类型。
                            if (data) {
                                //删除成功，刷新列表。
                                pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                alert("删除市场活动失败");
                            }
                        }
                    })
                }
            }
        }

        //复选框单击事件
        function changeSelect() {
            /*
            拿到选中的个数
            var checkedLen = $(":checkbox[name=selectOne]:checked").length;
            拿到总个数
            var allChekLen = $(":checkbox[name=selectOne]").length;
            相等则勾选全选复选框
            if(checkedLen === allCheckLen){
                $("#selectAll").prop("checked",true);
            }else {
                $("#selectAll").prop("checked",false);
            }
            一行搞定*/
            $("#selectAll").prop("checked",
                $(":checked[name=selectOne]").length ===
                $(":checkbox[name=selectOne]").length);
        }

        //全选框单击事件
        function changeAllSelect() {
            // $("input[name=selectOne]").prop("checked",this.checked);
            $(":checkbox[name=selectOne]").prop("checked", this.checked);
        }

        //查询市场活动列表
        function searchActivityList() {
            //每次点击查询时，需要把搜索框中的内容保存到隐藏域中
            $("#hidden-name").val($.trim($("#search-name").val()));
            $("#hidden-owner").val($.trim($("#search-owner").val()));
            $("#hidden-startDate").val($.trim($("#search-startDate").val()));
            $("#hidden-endDate").val($.trim($("#search-endDate").val()));
            pageList(1, 2);
        }

        //刷新市场活动列表
        function pageList(pageNo, pageSize) {
            /*
            对于所有的关系型数据库，做前端的分页相关操作的基础组件
            就是pageNo和pageSize
            pageNo:页码
            pageSize:每页展现的记录数

            pageList方法：就是发出ajax请求到后台，从后台取得最新的市场活动信息列表数据
            通过响应回来的数据，局部刷新市场活动信息列表

            我们都在哪些情况下，需要调用pageList方法（什么情况下需要刷新一下市场活动列表）
            （1）点击左侧菜单中的"市场活动"超链接，需要刷新市场活动列表，调用pageList方法
            （2）添加，修改，删除后，需要刷新市场活动列表，调用pageList方法
            （3）点击查询按钮的时候，需要刷新市场活动列表，调用pageList方法
            （4）点击分页组件的时候，调用pageList方法

            以上为pageList方法制定了六个入口，也就是说，在以上6个操作执行完毕后，
            我们必须要调用pageList方法，刷新市场活动信息列表*/
            // alert("刷新市场活动列表");
            //查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
            $("#search-name").val($("#hidden-name").val());
            $("#search-owner").val($("#hidden-owner").val());
            $("#search-startDate").val($("#hidden-startDate").val());
            $("#search-endDate").val($("#hidden-endDate").val());
            $.ajax({
                url: "workbench/activity/pageList.do",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "name": $.trim($("#search-name").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "startDate": $.trim($("#search-startDate").val()),
                    "endDate": $.trim($("#search-endDate").val()),
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    /*  data
                        我们需要的：市场活动信息列表
                        [{市场活动1},{2},{3}] List<Activity> aList
                        一会分页插件需要的：查询出来的总记录数
                        {"total":100} int total

                        {"total":100,"dataList":[{市场活动1},{2},{3}]}
                    */      //字符串拼接
                    // alert("查询成功!")
                    var html = "";
                    $.each(data.dataList, function (i, n) {
                        html += '<tr class="active">'
                        //这个复选框的id属性，是因为修改和删除的时候。需要传入后台一个id值。
                        html += '<td><input type="checkbox" value="' + n.id +
                            '" name="selectOne"/></td>'
                        html +=
                            '<td><a style="text-decoration: none; cursor: pointer;"onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">' + n.name + '</a></td>'
                        html += '<td>' + n.owner + '</td>'
                        html += '<td>' + n.startDate + '</td>'
                        html += '<td>' + n.endDate + '</td>'
                        html += '</tr>'
                    })
                    $("#activityBody").html(html);
                    var totalPages = data.total % pageSize === 0 ? data.total /
                        pageSize : parseInt(data.total / pageSize) + 1;
                    //展现分页
                    $("#activityPage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数

                        visiblePageLinks: 3, // 显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        //该回调函数时在，点击分页组件的时候触发的
                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        }
                    });
                }

            })
        }

        //保存市场活动记录
        function save() {
            $.ajax({
                url: "workbench/activity/save.do",
                data: {
                    "owner": $.trim($("#create-owner").val()),
                    "name": $.trim($("#create-name").val()),
                    "startDate": $.trim($("#create-startDate").val()),
                    "endDate": $.trim($("#create-endDate").val()),
                    "cost": $.trim($("#create-cost").val()),
                    "description": $.trim($("#create-description").val())
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    /*
                        data
                        {"success":true/false}
                     */
                    if (data.success) {
                        //成功
                        alert("添加成功！");
                        //刷新市场活动信息列表（局部刷新）
                        pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                        //清空添加操作模态窗口中的数据
                        //提交表单
                        // $("#activityAddForm").submit();
                        //重置表单,jQuery不提供reset方法，原生js提供了。
                        //jQuery转dom对象。数组[下标]。dom转jQuery，$(dom)
                        // $("#activityAddForm")[0].reset();
                        $("#createActivityModal").modal("hide");
                    } else {
                        alert("添加市场活动失败");
                    }
                },
                error: function () {
                    alert("服务器处理请求发生错误。")
                }
            })
        }

        //单击添加按钮事件
        function add() {
            //日历插件
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
            <%--alert("666" + "${user.name}");--%>
            //在展示模拟窗口之前，需要走一遍后台，拿到所有者下拉列表的数据。
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
                    $("#create-owner").html(html);
                    //将下拉列表的默认设置为当前用户。
                    var id = "${user.id}";
                    $("#create-owner").val(id);
                }
            })
            $("#createActivityModal").modal("show");
            /*
            操作模态窗口的方式：
                需要操作的模态窗口的jquery对象，调用modal方法，为该方法传递参数 show:打开模态窗口   hide：关闭模态窗口
            */
            //这个展示模态窗口，如果使用ajax，需要放在ajax里面，因为ajax请求是异步的。
            //或者改成同步的ajax请求。
        }

        //单击编辑按钮事件
        function edit() {
            //日历插件
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            var $xz = $(":checked[name=selectOne]");
            if ($xz.length === 0) {
                alert("请选择一条你要修改的记录")
            } else if ($xz.length >= 2) {
                alert("只能选择一条记录进行修改")
            } else {
                //在展示模拟窗口之前，需要走一遍后台，拿到所有者下拉列表的数据和市场活动数据。
                $.ajax({
                    url: "workbench/activity/getUserListAndActivity.do",
                    data: {"id": $xz.val()},
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        /*
                            data:
                            uList       不需要传入，直接查询所有的用户。
                            [{"id":?,"name":?,"loginAct":?.......},{2},{3}...]
                            activity    需要传入市场活动的id值。
                        */
                        var html = "";
                        //data是集合，n是对象。
                        $.each(data.uList, function (i, n) {
                            html += "<option value = '" + n.id + "'>" + n.name +
                                "</option>";
                        })
                        //将html加入下拉列表组件。
                        $("#edit-owner").html(html);
                        //将下拉列表的默认设置为当前用户。
                        $("#edit-id").val(data.activity.id);
                        $("#edit-owner").val(data.activity.owner);
                        $("#edit-name").val(data.activity.name);
                        $("#edit-startDate").val(data.activity.startDate);
                        $("#edit-endDate").val(data.activity.endDate);
                        $("#edit-cost").val(data.activity.cost);
                        $("#edit-description").val(data.activity.description);

                        //展示编辑模态窗口。
                        $("#editActivityModal").modal("show");
                    }
                })


            }

        }

    </script>
</head>
<body>
<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-startDate">
<input type="hidden" id="hidden-endDate">
<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form id="activityAddForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-owner"
                               class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">

                            </select>
                        </div>
                        <label for="create-name"
                               class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control"
                                   id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startDate"
                               class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <%--加入日期插件。--%>
                            <input type="text" class="form-control time"
                                   id="create-startDate">
                        </div>
                        <label for="create-endDate"
                               class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time"
                                   id="create-endDate">
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost"
                               class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-description"
                               class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3"
                                      id="create-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存
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
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">
                    <%--在修改模块的表单这里，放一个隐藏作用域--%>
                    <input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-owner"
                               class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control"
                                    id="edit-owner">
                                <%--<option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="edit-name"
                               class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control"
                                   id="edit-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startDate"
                               class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time"
                                   id="edit-startDate">
                        </div>
                        <label for="edit-endDate"
                               class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endDate"
                                   value="2020-10-20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost"
                               class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost"
                            >
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description"
                               class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3"
                                          id="edit-description"></textarea>
                                    <!--
									关于文本域textarea：
										（1）一定是要以标签对的形式来呈现,正常状态下标签对要紧紧的挨着
										（2）textarea虽然是以标签对的形式来呈现的，但是它也是属于表单元素范畴
												我们所有的对于textarea的取值和赋值操作，应该统一使用val()方法（而不是html()方法）
								-->

                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" data-dismiss="modal"
                        id="updateBtn">更新
                </button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">
        <%--这是上面的查询表单--工具条。--%>
        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form"
                  style="position: relative;top: 8%; left: 5px;">
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control" type="text" id="search-startDate">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control" type="text" id="search-endDate">
                    </div>
                </div>

                <button id="searchBtn" type="button" class="btn btn-default">查询
                </button>

            </form>
        </div>
        <%--这又是一个工具条，是添加、删除、修改，操作市场活动列表的工具条。--%>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">

                <%--
                    点击创建按钮，观察两个属性和属性值

                    data-toggle="modal"：
                        表示触发该按钮，将要打开一个模态窗口

                    data-target="#createActivityModal"：
                        表示要打开哪个模态窗口，通过#id的形式找到该窗口


                    现在我们是以属性和属性值的方式写在了button元素中，用来打开模态窗口
                    但是这样做是有问题的：
                        问题在于没有办法对按钮的功能进行扩充

                    所以未来的实际项目开发，对于触发模态窗口的操作，一定不要写死在元素当中，
                    应该由我们自己写js代码来操作
                --%>
                <button type="button" class="btn btn-primary" id="addBtn"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>

        </div>
        <%--这个是市场活动列表--%>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="selectAll"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="activityBody">
                <%--<tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div id="activityPage"></div>
        </div>

    </div>

</div>
</body>
</html>