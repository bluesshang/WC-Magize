
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
    <table style="padding-bottom:10px;margin-bottom:10px">
        <tr>
            <td>
                <ul class="nav nav-pills nav-pills-ext">
                    <li data-toggle="pill"id="unfoldAll"><a href="#">展开所有统计项</a></li>
                    <li data-toggle="pill" class="active"  id="foldAll"><a href="#">折叠所有统计项</a></li>
                    <li data-toggle="pill"id="noGroup"><a href="#">不分组统计</a></li>
                </ul>
            </td>
            <td style="padding-right:40px">&nbsp;</td>
            <td>
                <ul class="nav nav-pills nav-pills-ext">
                    <li data-toggle="pill" class="active" id="byDate"><a href="#">按时间统计</a></li>
                    <li data-toggle="pill" id="byEmployee"><a href="#">按业务员统计</a></li>
                </ul>
            </td>
            <td>
            </td>
        </tr>
    </table>
    <div id="dataViewer"></div>
</div>

<script>
    //var level = <%=(int)Session["userLevel"]%>;

    function queryNow()
    {
        $.ajax({
            type: 'post',
            url: 'do.aspx',
            //data: "op=1&data=" + JSON.stringify(dataViewer.itemsSource.items), //$("#form1").serialize(),
            data: "op=statistics",
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
                    //cv.trackChanges = true;
                    dataViewer.itemsSource = cv;

                    cv.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription("ym"));
                    dataViewer.collapseGroupsToLevel(0);

                    dataViewer.columns.getColumn('employee').dataMap = new wijmo.grid.DataMap(data.employees, "id", "name");

                    //cv.currentChanged.addHandler(function (sender, args) {
                    //    if (cv.currentItem != null)
                    //        $("#bottomTip").html(cv.currentItem.para.text);
                    //    //refreshModifyInfo(cv)
                    //});

                    //cv.pageSize = 10;
                    //updateNaviagteButtons();
                }
            },
            error: function (o, message, errInfos) {
                //alert(message + "\n" + errInfos.message + "\n" + errInfos.stack);
                //throw "too high";
                $("#msgboxTitle").html("<span class=\"glyphicon glyphicon-remove\"/> 操作出现错误");
                //$("#msgboxBody").html("" + message + ":" + errInfos.message + "<br/><code>" + errInfos.stack + "</code>");
                $("#msgboxBody").html(message + ":" + errInfos);
                $("#msgbox").modal();
            }
        });
    }
    $(document).ready(function () {
        //var theDate = new Date();

        //$("#paragraphText").onchange(function () {
        //$("#paragraphText").on('keyup', function () {
        //    $("#paragraphInfo").html("共 " + $("#paragraphText").val().length + " 字符。");
        //});
        //var lockField = <%=((int)Session["userLevel"] == 0 ? "false" : "true")%>;
        //var visibleField = <%=((int)Session["userLevel"] >= 2 ? "false" : "true")%>;

        dataViewer = new wijmo.grid.FlexGrid('#dataViewer', {
            showSelectedHeaders: 'All',
            itemsSource: null,
            autoGenerateColumns: false,
            allowDelete: false,
            autoClipboard: true,
            showGroups: true,
            //autoSizeMode:true,
            //sortRowIndex:true,
            //allowAddNew: true,
            isReadOnly: true,
            columns: [
                //{ header: '-', binding: 'valid', width: 30, format: 'b', dataType:"Boolean" },
                //{ header: '#ID', binding: 'id', width: 80, isReadOnly: true },
                //{ header: '类型', binding: 'type', width: 100 },
                //{ header: '登报日期', binding: 'publishTime', dataType: "Date"},
                //{ header: '被告', binding: 'accused'},
                //{ header: '原告', binding: 'accuser'},
                //{ header: '法院', binding: 'court'},
                //{ header: '法庭', binding: 'courtRoom'},
                //{ header: '法官', binding: 'judge'},
                //{ header: '电话', binding: 'telephone'},
                //{ header: '发票号', binding: 'invoiceNumber', visible: level <= 1 },
                //{ header: '报刊类型', binding: 'magazine', isReadOnly: level != 0},
                //{ header: '法院地址', binding: 'courtAddress'},
                //{ header: '版面', binding: 'magazinePage'},
                { header: '时间', binding: 'ym' },
                { header: '业务员', binding: 'employee', width: 100},
                //{ header: '案件类型', binding: 'title', isReadOnly: lockField },
                //{ header: '录入日期', binding: 'date', dataType: "Date", isReadOnly: true },
                { header: '业务数', binding: 'orders', dataType: "Number"},
                { header: '应收金额', binding: 'receivable', dataType: "Number", format: 'c'},
                { header: '实收金额', binding: 'arrival', dataType: "Number", format: 'c' },
                // { header: '来款日期', binding: 'arrivalTime', dataType: "Date", isReadOnly: true, visible: level <= 1 },
                //{ header: '来款途径', binding: 'arrivalFrom', visible: level <= 1 },
                //{ header: '状态', binding: 'status', width: '*', isReadOnly: true },
                //{ header: '备注', binding: 'remark'}
            ],
            //cellEditEnded: function (e) {
            //    //dataViewer.finishEditing();
            //    //dataViewer.refresh(true);
            //    //dataViewer.itemsSource.commitEdit();
            //    //alert(dataViewer.itemsSource.itemsEdited.length);
            //    refreshModifyInfo(dataViewer.itemsSource);
            //},
            //deletedRow: function (e) {
            //    refreshModifyInfo(dataViewer.itemsSource);
            //}
            //new wijmo.odata.ODataCollectionView(
            //'http://services.odata.org/V4/Northwind/Northwind.svc/',
            //'Order_Details_Extendeds'),
        });

        $("#byDate").click(function () {
            dataViewer.itemsSource.groupDescriptions.clear();
            dataViewer.itemsSource.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription("ym"));

        });
        $("#byEmployee").click(function () {
            dataViewer.itemsSource.groupDescriptions.clear();
            dataViewer.itemsSource.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription("employee"));
        });

        $("#unfoldAll").click(function () {
            dataViewer.collapseGroupsToLevel(1);
        });
        $("#foldAll").click(function () {
            dataViewer.collapseGroupsToLevel(0);
        });
        $("#noGroup").click(function () {
            dataViewer.itemsSource.groupDescriptions.clear();
        });

        //dataViewer.columns.getColumn('type').dataMap = new wijmo.grid.DataMap(bizTypes, "id", "name");
        ////dataViewer.columns.getColumn('employee').dataMap = new wijmo.grid.DataMap(employees, "id", "name");
        //dataViewer.columns.getColumn('magazine').dataMap = new wijmo.grid.DataMap(magazineNames, "id", "name");

        dataViewer.__grphdrExtInfo = function (fld, val, fldDisp, valDisp, rs) {
            //return fld + " ==> " + rs.length;
            var totalReceivable = 0.0,
                totalArrival = 0.0,
                totalUnarrival = 0.0,
                n = 0;

            //for (i = 0; i < rs.length; i++) {
            //var fullRs = dataViewer.itemsSource.sourceCollection;

            for (i = 0; i < rs.length; i++) {
                totalReceivable += (rs[i].receivable == "" ? 0 : eval(rs[i].receivable));
                if (rs[i].arrival != "")
                    totalArrival += eval(rs[i].arrival);
                else totalUnarrival += 1;
                n += 1;
            }

            return "<span>" + valDisp + " (" + n + " 条记录, 应收帐款共计： " + wijmo.Globalize.formatNumber(totalReceivable, 'c')
                + "，实收： " + wijmo.Globalize.formatNumber(totalArrival, 'c') 
                + "，未到帐： " + totalUnarrival + " 笔)"
                + "</span>";
        }

        dataViewerFilter = new wijmo.grid.filter.FlexGridFilter(dataViewer);
        //dataViewerFilter.filterApplied = function(e) {
        //    updateNaviagteButtons();
        //}

        queryNow();


        //$("#saveBizdata").attr("disabled", level >= 2);
        //updateNaviagteButtons();
        //if (level >= 2)
        //    $("#saveBizdata").hide();
    });
</script>
