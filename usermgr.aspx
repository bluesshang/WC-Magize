
<%@ Page Language="C#" %>
<%@ import namespace="System" %>
<%@ import namespace="System.Web.UI" %>
<%
    if (Session["userId"] == null)
    {
        Response.Redirect("index.aspx", true);
    }
%>

<div class="container">
    <span class="glyphicon glyphicon-user" style="font-size:80px"></span>
    <div id="dataViewer" class="panel panel-primary"></div>
    <div id="modifyInfos"></div>
    <!--/div-->
    <button type="button" id="saveBizdata" class="btn btn-success btn-lg">
        <span class="glyphicon glyphicon-floppy-saved"></span> 保存修改
    </button>
</div>

<script>

    function refreshModifyInfo(cv) {
        cv.commitEdit();
        if (cv.itemsEdited.length > 0 || cv.itemsRemoved.length > 0 || cv.itemsAdded.length > 0) {
            $("#modifyInfos").html("<div class='alert alert-warning'><span class='glyphicon glyphicon-info-sign'></span> 修改记录：修改 " + cv.itemsEdited.length + " 条，删除 " + cv.itemsRemoved.length + " 条，新增 " + cv.itemsAdded.length + " 条。</div>");
            $("#saveBizdata").attr("disabled", false);
        }
    }

    function queryNow()
    {
        $("#modifyInfos").html("");
        $.ajax({
            type: 'post',
            url: 'do.aspx',
            //data: "op=1&data=" + JSON.stringify(dataViewer.itemsSource.items), //$("#form1").serialize(),
            data: "op=userlist",
            //data: "op=new&data=" + JSON.stringify(person), //$("#form1").serialize(),
            //data: $("#frmParagrahInput").serialize(),
            cache: false,
            dataType: 'json',
            success: function (data) {
                if (eval(data.status) == 0) {
                    //dataViewer.itemsSource = null;
                    //$("#msgboxTitle").html("<span class=\"glyphicon glyphicon-ok\"/> 业务数据保存成功");
                    //$("#msgboxBody").html("总共成功保存 " + data.successNum + " 条业务数据。[message: " + data.message + "]");
                    //$("#msgbox").modal();
                    var cv = new wijmo.collections.CollectionView(data.records);
                    cv.trackChanges = true;
                    dataViewer.itemsSource = cv;
                    //cv.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription("employee"));
                    //dataViewer.collapseGroupsToLevel(foldLevel);

                    cv.currentChanged.addHandler(function (sender, args) {
                        if (cv.currentItem != null)
                            $("#bottomTip").html(cv.currentItem.regions);
                        refreshModifyInfo(cv)
                    });

                    //cv.pageSize = 10;
                    //updateNaviagteButtons();
                }
            },
            error: function (o, message) {
                alert(message);
            }
        });
    }
    $(document).ready(function () {
        $("#searchNow").click(function () {
            queryNow();
        });

        $("#saveBizdata").click(function () {
            var delIDs = "", modifies = [], news = [];
            var cv = dataViewer.itemsSource;

            for (i = 0; i < cv.itemsRemoved.length; i++) {
                delIDs += (cv.itemsRemoved[i].id + ",");
            }
            delIDs += "0";

            for (i = 0; i < cv.itemsEdited.length; i++) {
                modifies.push(cv.itemsEdited[i]);
                //if (cv.itemsEdited[i].publishTime == null) {
                //    alert("登报日期不能为空：ID=" + cv.itemsEdited[i].id);
                //    return;
                //}
            }

            for (i = 0; i < cv.itemsAdded.length; i++) {
                news.push(cv.itemsAdded[i]);
                //if (cv.itemsEdited[i].publishTime == null) {
                //    alert("登报日期不能为空：ID=" + cv.itemsEdited[i].id);
                //    return;
                //}
            }

            $.ajax({
                type: 'post',
                url: 'do.aspx',
                //data: "op=1&data=" + JSON.stringify(dataViewer.itemsSource.items), //$("#form1").serialize(),
                data: "op=updateUser&modifies=" + JSON.stringify(modifies) + "&delete=" + delIDs + "&news=" + JSON.stringify(news),
                //data: "op=new&data=" + JSON.stringify(person), //$("#form1").serialize(),
                //data: $("#frmParagrahInput").serialize(),
                cache: false,
                dataType: 'json',
                success: function (data) {
                    if (eval(data.status) == 0) {
                        //dataViewer.itemsSource = null;
                        //$("#msgboxTitle").html("<span class=\"glyphicon glyphicon-ok\"/> 业务数据保存成功");
                        //$("#msgboxBody").html("总共成功保存 " + data.successNum + " 条业务数据。[message: " + data.message + "]");
                        var info = "总共成功保存 " + data.successNum + " 条用户信息 。";
                        $("#msgboxTitle").html("<span class=\"glyphicon glyphicon-ok\"/> 数据保存成功");
                        if (eval(data.errorNum) > 0) {
                            info += "以下 " + data.errorNum + " 条数据未能成功保存：" + data.errorMessages;
                        }
                        $("#msgboxBody").html(info);
                        $("#msgbox").modal();
                        //var cv = new wijmo.collections.CollectionView(data.records);
                        //cv.trackChanges = true;
                        //dataViewer.itemsSource = cv;
                        //cv.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription("employeeName"));
                        //dataViewer.collapseGroupsToLevel(foldLevel);

                        cv.currentChanged.addHandler(function (sender, args) {
                            $("#bottomTip").html(cv.currentItem.regions);
                            if (cv.itemsEdited.length > 0 || cv.itemsRemoved.length > 0) {
                                $("#modifyInfos").html("<div class='alert alert-warning'><span class='glyphicon glyphicon-info-sign'></span> 修改记录：修改 " + cv.itemsEdited.length + " 条，删除 " + cv.itemsRemoved.length + " 条。</div>");
                                $("#saveBizdata").attr("disabled", false);
                            }
                        });
                        queryNow();
                        $("#saveBizdata").attr("disabled", true);
                    }
                },
                error: function (o, message) {
                    alert(message);
                }
            });
        });

        //$("#paragraphText").onchange(function () {
        //$("#paragraphText").on('keyup', function () {
        //    $("#paragraphInfo").html("共 " + $("#paragraphText").val().length + " 字符。");
        //});

        dataViewer = new wijmo.grid.FlexGrid('#dataViewer', {
            showSelectedHeaders: 'All',
            itemsSource: null,
            autoGenerateColumns: false,
            allowDelete: true,
            autoClipboard: true,
            //showGroups: true,
            //autoSizeMode:true,
            //sortRowIndex:true,
            allowAddNew: true,
            columns: [
                //{ header: '-', binding: 'valid', width: 30, format: 'b', dataType:"Boolean" },
                { header: 'ID', binding: 'id', width: 80, isReadOnly: true },
                { header: '登录名', binding: 'userid'},
                { header: '姓名', binding: 'name'},
                { header: '密码', binding: 'passwd'},
                { header: '用户级别', binding: 'level' },
                { header: '业务量', binding: 'orders', isReadOnly: true, dataType: "Number" },
                { header: '应收帐款', binding: 'receivable', isReadOnly: true, dataType: "Number", format: 'c' },
                { header: '实收帐款', binding: 'arrival', isReadOnly: true, dataType: "Number", format: 'c' },
                { header: '备注', binding: 'remark' },
                { header: '上一次登录', binding: 'lastLogin', isReadOnly: true },
                { header: '总登录次数', binding: 'loginTimes', isReadOnly: true, dataType: "Number" }
            ],
            cellEditEnded: function (e) {
                //alert(dataViewer.itemsSource.itemsEdited.length);
                refreshModifyInfo(dataViewer.itemsSource);
            },
            deletedRow: function (e) {
                refreshModifyInfo(dataViewer.itemsSource);
            }
            //new wijmo.odata.ODataCollectionView(
            //'http://services.odata.org/V4/Northwind/Northwind.svc/',
            //'Order_Details_Extendeds'),
        });

        dataViewer.columns.getColumn('level').dataMap = new wijmo.grid.DataMap(userLevels, "id", "name");
        dataViewerFilter = new wijmo.grid.filter.FlexGridFilter(dataViewer);

        queryNow();

        //updateNaviagteButtons();
    });
</script>
