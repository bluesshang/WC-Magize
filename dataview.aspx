
<%@ Page Language="C#" %>
<%@ import namespace="System" %>
<%@ import namespace="System.Web.UI" %>
<%
    if (Session["userId"] == null)
    {
        Response.Redirect("index.aspx", true);
    }
%>

<div class="container" id="queryPanel">
    <h2><span class="glyphicon glyphicon-edit"></span> 业务数据处理</h2>
    <span style="font-size:16px">选定需要查看的登报日期范围：从</span>
    <div id="dateBegin"></div>
    <span>到</span>
    <div id="dateEnd"></div>
    <button type="submit" class="btn btn-default" id="searchNow"><span class="glyphicon glyphicon-search"></span></button>
    <table>
        <tr>
            <td>
                <ul class="nav nav-pills nav-pills-ext">
                    <li data-toggle="pill" class="active" id="unfoldAll"><a href="#">展开所有统计项</a></li>
                    <li data-toggle="pill" id="foldAll"><a href="#">折叠所有统计项</a></li>
                </ul>
            </td>
            <td>&nbsp;</td>
            <td>
                <ul class="nav nav-pills nav-pills-ext">
                    <li data-toggle="pill"id="viewYear"><a href="#">当年</a></li>
                    <li data-toggle="pill" class="active"  id="viewMonth"><a href="#">当月</a></li>
                    <li data-toggle="pill" id="viewDay"><a href="#">当天</a></li>
                </ul>
            </td>
            <td>
            </td>
        </tr>
    </table>
</div>

<div class="container" id="dataPanel">
    <p></p>
    <div style="padding-bottom:10px">
        <table border="0" style="width:100%">
            <tr><td>
                <input id="pagingInput" type="text" class="form-control col-md-1" style="width:80px" placeholder="0 or empty is for no paging." value="15" />
                &nbsp;
                <button type="button" class="btn btn-default" id="btnMoveToFirstPage">
                  <span class="glyphicon glyphicon-fast-backward"></span>
                </button>
                <button type="button" class="btn btn-default" id="btnMoveToPreviousPage">
                  <span class="glyphicon glyphicon-step-backward"></span>
                </button>
                <button type="button" class="btn btn-default" disabled style="width:100px" id="btnCurrentPage">
                </button>
                <button type="button" class="btn btn-default" id="btnMoveToNextPage">
                  <span class="glyphicon glyphicon-step-forward"></span>
                </button>
                <button type="button" class="btn btn-default" id="btnMoveToLastPage">
                  <span class="glyphicon glyphicon-fast-forward"></span>
                </button>
                <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
                <button type="button" class="btn btn-default"" id="btnMaximum">
                  <span class="glyphicon glyphicon-fullscreen"></span>
                </button>
                <button type="button" class="btn btn-default"" id="btnNormalWnd">
                  <span class="glyphicon glyphicon-unchecked"></span>
                </button>
                <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
                <button type="button" class="btn btn-default"" id="btnRefresh">
                  <span class="glyphicon glyphicon-refresh"></span>
                </button>
                <select id="groupMenu" header="<b>分组显示：</b> 业务员x">
                    <option>业务员</option>
                    <option>法院</option>
                    <option>法官</option>
                    <option>报刊类型</option>
                    <option>登报日期</option>
                    <option></option>
                    <option>不分组显示</option>
                </select>
                </td><td style="text-align:right">
                <span id="recordsInfo"></span>
                </td></tr>
            </table>
        </div>
    <!--div style="border:1px solid red"-->
    <div id="dataViewer" class="panel panel-primary"></div>
    <div id="modifyInfos"></div>
    <!--/div-->
    <button type="button" id="saveBizdata" class="btn btn-success btn-lg">
        <span class="glyphicon glyphicon-floppy-saved"></span> 保存修改
    </button>
    <button type="button" id="saveLayout" class="btn btn-lg">
        <span class="glyphicon glyphicon-star"></span> 保存页面布局
    </button>
</div>

<script>
    var session = null;

    try {
        session = JSON.parse('<%=dbutil.getSessionState((int)Session["userId"], "dataview.aspx")%>');
    } catch (e) {
        session = {
            pageSize: 15,
            layout: null,
            groupField: 0
        };
    }

    var grpDescs = [
        {field: "employee", disp: "业务员"},
        {field: "court", disp: "法院"},
        {field: "judge", disp: "法官"},
        {field: "magazine", disp: "报刊类型"},
        {field: "publishTime", disp: "登报日期"},
        {field: "-", disp: ""},
        {field: "no", disp: "不分组显示"},
    ];        

    var level = <%=(int)Session["userLevel"]%>;

    var foldLevel = 1, dateBegin = null, dateEnd = null;
    var lastPageIndex = 0, lastGrpFields = session.groupField;
    var mnGroup = null;

    function saveSessionState()
    {
        session.groupField = lastGrpFields;
        session.layout = dataViewer.columnLayout;
        session.pageSize = dataViewer.itemsSource.pageSize;

        $.ajax({
            type: 'post', url: 'do.aspx',
            data: "op=saveSession&state=" + JSON.stringify(session) + "&page=dataview.aspx",
            cache: false, dataType: 'json',
            success: function (data) {
                $("#saveLayout").hide();
                if (data.status != 0) {
                    alert("保存失败：" + data.message);
                }
            },
            error: function (o, message) {
                alert(message);
            }
        });
    }
    function refreshModifyInfo(cv)
    {
        cv.commitEdit();
        if (cv.itemsEdited.length > 0 || cv.itemsRemoved.length > 0) {
            $("#modifyInfos").html("<div class='alert alert-warning'><span class='glyphicon glyphicon-info-sign'></span> 修改记录：修改 " + cv.itemsEdited.length + " 条，删除 " + cv.itemsRemoved.length + " 条。</div>");
            $("#saveBizdata").attr("disabled", false);
        }
    }

    var btnFirstPage = document.getElementById('btnMoveToFirstPage'),
        btnPreviousPage = document.getElementById('btnMoveToPreviousPage'),
        btnNextPage = document.getElementById('btnMoveToNextPage'),
        btnLastPage = document.getElementById('btnMoveToLastPage'),
        btnCurrentPage = document.getElementById('btnCurrentPage');

    function updateNaviagteButtons() {
        var cv = dataViewer.itemsSource;
        if (cv.pageSize <= 0) {
            //document.getElementById('naviagtionPage').style.display = 'none';
            return;
        }

        //document.getElementById('naviagtionPage').style.display = 'block';

        if (cv.pageIndex === 0) {
            btnFirstPage.setAttribute('disabled', 'disabled');
            btnPreviousPage.setAttribute('disabled', 'disabled');
            btnNextPage.removeAttribute('disabled');
            btnLastPage.removeAttribute('disabled');
        } else if (cv.pageIndex === (cv.pageCount - 1)) {
            btnFirstPage.removeAttribute('disabled');
            btnPreviousPage.removeAttribute('disabled');
            btnLastPage.setAttribute('disabled', 'disabled');
            btnNextPage.setAttribute('disabled', 'disabled');
        } else {
            btnFirstPage.removeAttribute('disabled');
            btnPreviousPage.removeAttribute('disabled');
            btnNextPage.removeAttribute('disabled');
            btnLastPage.removeAttribute('disabled');
        }

        btnCurrentPage.innerHTML = (cv.pageIndex + 1) + ' / ' + cv.pageCount;
        lastPageIndex = cv.pageIndex;

        $("#recordsInfo").html(" 共 <b>" + cv.sourceCollection.length + "</b> 条记录，每页显示 <b>" + cv.pageSize + "</b> 条。");
    }
    function updateGroupInfo(idx)
    {
        var cv = dataViewer.itemsSource;
        lastGrpFields = idx;//grpDescs[menu.selectedIndex].field;
        //session.groupField = idx;

        mnGroup.header = "<span class='glyphicon glyphicon-search'></span> <b>分组显示：</b>" + grpDescs[idx].disp;

        cv.groupDescriptions.clear();
        if (grpDescs[idx].field == "no")
            return;
        cv.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription(grpDescs[idx].field));
        dataViewer.collapseGroupsToLevel(foldLevel);
    }
    function queryNow()
    {
        $("#modifyInfos").html("");
        $.ajax({
            type: 'post',
            url: 'do.aspx',
            //data: "op=1&data=" + JSON.stringify(dataViewer.itemsSource.items), //$("#form1").serialize(),
            data: "op=query&dateBegin=" + dateBegin.text + "&dateEnd=" + dateEnd.text,
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
                    evalDataQuery(data.records);
                    var cv = new wijmo.collections.CollectionView(data.records);
                    cv.trackChanges = true;
                    dataViewer.itemsSource = cv;
                    //cv.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription(lastGrpFields));
                    //dataViewer.collapseGroupsToLevel(foldLevel);
                    updateGroupInfo(lastGrpFields);

                    dataViewer.columns.getColumn('employee').dataMap = new wijmo.grid.DataMap(data.employees, "id", "name");

                    cv.currentChanged.addHandler(function (sender, args) {
                        if (cv.currentItem != null)
                            $("#bottomTip").html(cv.currentItem.para.text);
                        refreshModifyInfo(cv)
                    });
                    cv.pageSize = wijmo.Globalize.parseInt($("#pagingInput").val());
                    //cv.pageIndex = lastPageIndex;
                    cv.moveToPage(lastPageIndex);
                    updateNaviagteButtons();
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
        $("#pagingInput").val(session.pageSize);

        //var theDate = new Date();
        dateBegin = new wijmo.input.InputDate('#dateBegin', {
            //min: new Date(2014, 8, 1),
            format: 'yyyy-M-d',
            value: new Date(<%=DateTime.Now.Year%>, <%=DateTime.Now.Month - 1%>, 1)
        });
        dateEnd = new wijmo.input.InputDate('#dateEnd', {
            format: 'yyyy-M-d',
            value: new Date(<%=DateTime.Now.Year%>, <%=DateTime.Now.Month - 1%>, <%=DateTime.Now.Day%>)
        });

        <%
            string month = Request["month"];
            if (month != null && month != "")
            {
                Response.Write("dateBegin.text = '" + DateTime.Now.Year + "-" + month + "-1';");
                Response.Write("dateEnd.text = '" + DateTime.Now.Year + "-" + month + "-31';");
            }
        %>

        $("#saveBizdata").attr("disabled", true);

        $("#searchNow").click(function () {
            queryNow();
        });

        $("#saveLayout").click(function () {
            saveSessionState();
        });

        $("#btnRefresh").click(function () {
            queryNow();
        });

        $("#saveBizdata").click(function () {
            var delIDs = "", modifies = [];
            var cv = dataViewer.itemsSource;

            for (i = 0; i < cv.itemsRemoved.length; i++) {
                delIDs += (cv.itemsRemoved[i].id + ",");
            }
            delIDs += "0";

            for (i = 0; i < cv.itemsEdited.length; i++) {
                modifies.push(cv.itemsEdited[i]);
                if (cv.itemsEdited[i].publishTime == null) {
                    alert("登报日期不能为空：ID=" + cv.itemsEdited[i].id);
                    return;
                }

                if (cv.itemsEdited[i].receivable == null)
                    cv.itemsEdited[i].receivable = 88888888;
                if (cv.itemsEdited[i].arrival == null)
                    cv.itemsEdited[i].arrival = 88888888;
                if (cv.itemsEdited[i].arrivalOld == null)
                    cv.itemsEdited[i].arrivalOld = 88888888;
            }

            $.ajax({
                type: 'post',
                url: 'do.aspx',
                //data: "op=1&data=" + JSON.stringify(dataViewer.itemsSource.items), //$("#form1").serialize(),
                data: "op=update&modify=" + JSON.stringify(modifies) + "&delete=" + delIDs,
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
                        //var cv = new wijmo.collections.CollectionView(data.records);
                        //cv.trackChanges = true;
                        //dataViewer.itemsSource = cv;
                        //cv.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription("employeeName"));
                        //dataViewer.collapseGroupsToLevel(foldLevel);

                        //cv.currentChanged.addHandler(function (sender, args) {
                        //    $("#bottomTip").html(cv.currentItem.para.text);
                        //    if (cv.itemsEdited.length > 0 || cv.itemsRemoved.length > 0) {
                        //        $("#modifyInfos").html("<div class='alert alert-warning'><span class='glyphicon glyphicon-info-sign'></span> 修改记录：修改 " + cv.itemsEdited.length + " 条，删除 " + cv.itemsRemoved.length + " 条。</div>");
                        //        $("#saveBizdata").attr("disabled", false);
                        //    }
                        //});
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
        //var lockField = <%=((int)Session["userLevel"] == 0 ? "false" : "true")%>;
        //var visibleField = <%=((int)Session["userLevel"] >= 2 ? "false" : "true")%>;

        dataViewer = new wijmo.grid.FlexGrid('#dataViewer', {
            showSelectedHeaders: 'All',
            itemsSource: null,
            autoGenerateColumns: false,
            allowDelete: level == 0,
            autoClipboard: true,
            showGroups: true,
            //autoSizeMode:true,
            //sortRowIndex:true,
            //allowAddNew: true,
            isReadOnly: level > 2,
            columns: [
                //{ header: '-', binding: 'valid', width: 30, format: 'b', dataType:"Boolean" },
                { header: '#ID', binding: 'id', width: 80, isReadOnly: true },
                { header: '登报日期', binding: 'publishTime', width:100, dataType: "Date", isReadOnly: level != 0 && level != 2},
                { header: '报刊类型', binding: 'magazine', width:120, isReadOnly: level > 2},
                { header: '被告', binding: 'accused', isReadOnly: level > 2 },
                { header: '原告', binding: 'accuser', isReadOnly: level > 2 },
                { header: '法院', binding: 'court', width:250, isReadOnly: level > 2 },
                { header: '应收金额', binding: 'receivable', dataType: "Number", required:false, format: 'c', visible: level <= 2 },
                { header: '实收金额', binding: 'arrival', dataType: "Number", required:false, format: 'c', visible: level <= 1 },
                { header: '来款途径', binding: 'arrivalFrom', visible: level <= 1 },
                { header: '法庭', binding: 'courtRoom',  isReadOnly: level > 2 },
                { header: '法官', binding: 'judge', visible: level <= 1 || level == 2 },
                { header: '电话', binding: 'telephone', visible: level <= 1 || level == 2 },
                { header: '发票号', binding: 'invoiceNumber', visible: level <= 1 || level == 2 },
                { header: '版面', binding: 'magazinePage'},
                { header: '类型', binding: 'type', width: 100, isReadOnly: level != 0 && level != 2 },
                { header: '业务员', binding: 'employee', width: 100, isReadOnly: level != 0 && level != 2, visible: level == 0 || level == 2},
                //{ header: '案件类型', binding: 'title', isReadOnly: lockField },
                //{ header: '录入日期', binding: 'date', dataType: "Date", isReadOnly: true },
                { header: '来款日期', binding: 'arrivalTime', dataType: "Date", isReadOnly: true, visible: level <= 1 },
                //{ header: '状态', binding: 'status', width: '*', isReadOnly: true },
                { header: '法院地址', binding: 'courtAddress'},
                { header: '邮编', binding: 'postcode'},
                { header: '备注', binding: 'remark'}
            ],
            cellEditEnded: function (e) {
                //dataViewer.finishEditing();
                //dataViewer.refresh(true);
                //dataViewer.itemsSource.commitEdit();
                //alert(dataViewer.itemsSource.itemsEdited.length);
                refreshModifyInfo(dataViewer.itemsSource);
            },
            deletedRow: function (e) {
                refreshModifyInfo(dataViewer.itemsSource);
            },
            resizedColumn: function(e) {
                $("#saveLayout").show();
                //session.layout = dataViewer.columnLayout;
            },
            draggedColumn: function(e) {
                $("#saveLayout").show();
                //session.layout = dataViewer.columnLayout;
            }
            //new wijmo.odata.ODataCollectionView(
            //'http://services.odata.org/V4/Northwind/Northwind.svc/',
            //'Order_Details_Extendeds'),
        });

        <%
            //string layout = dbutil.getFlexgridLayout("layoutA", (int)Session["userId"]);
            //if (layout != null)
            //{
            //    Response.Write("dataViewer.columnLayout = '" + layout + "';");
            //}
        %>
        if (session.layout != null) {
            dataViewer.columnLayout = session.layout;
        }
        //alert(JSON.stringify(dataViewer.columns));
        //{
        //    var cols = dataViewer.columns;
        //    var colinfos = [];
        //    for (i = 0; i < cols.length; i++) {
        //        colinfos.push({
        //            header: cols[i].header,
        //            binding: cols[i].binding,
        //            dataType: cols[i].dataType,
        //            isReadOnly: cols[i].isReadOnly,
        //            format: cols[i].format,
        //            index: cols[i].index,
        //            width: cols[i].width,
        //            renderSize: cols[i].renderSize
        //        });
        //    }
        //    //alert(JSON.stringify(colinfos));
            

        //    //dataViewer.columns = colinfos;
        //    //dataViewer.setco
        //}

        $("#unfoldAll").click(function () {
            foldLevel = 1;
            dataViewer.collapseGroupsToLevel(foldLevel);
        });

        $("#foldAll").click(function () {
            foldLevel = 0;
            dataViewer.collapseGroupsToLevel(foldLevel);
        });

        $("#viewYear").click(function () {
            dateBegin.text = '<%=DateTime.Now.Year%>-1-1';
            dateEnd.text = '<%=DateTime.Now.Year%>-<%=DateTime.Now.Month%>-31';
            queryNow();
        });

        $("#viewMonth").click(function () {
            dateBegin.text = '<%=DateTime.Now.Year%>-<%=DateTime.Now.Month%>-1';
            dateEnd.text = '<%=DateTime.Now.Year%>-<%=DateTime.Now.Month%>-31';
            queryNow();
        });

        $("#viewDay").click(function () {
            dateBegin.text = '<%=DateTime.Now.ToString("yyyy-M-d")%>';
            dateEnd.text = '<%=DateTime.Now.ToString("yyyy-M-d")%>';
            queryNow();
        });

        $("#btnMaximum").click(function () {
            $("#tabCtrlPanel").hide();
            $("#queryPanel").hide();
            $("#dataPanel").css("width", $(document.body).width() - 60);
            $("#dataPanel").css("margin-right", "20px");
            $("#dataPanel").css("margin-left", "20px");
            dataViewer.invalidate();
        });

        $("#btnNormalWnd").click(function () {
            $("#tabCtrlPanel").show();
            $("#queryPanel").show();
            $("#dataPanel").css("width", $("#queryPanel").width() + 30);
            $("#dataPanel").css("margin-right", "auto");
            $("#dataPanel").css("margin-left", "auto");
        });

        dataViewer.columns.getColumn('type').dataMap = new wijmo.grid.DataMap(bizTypes, "id", "name");
        //dataViewer.columns.getColumn('employee').dataMap = new wijmo.grid.DataMap(employees, "id", "name");
        dataViewer.columns.getColumn('magazine').dataMap = new wijmo.grid.DataMap(magazineNames, "id", "name");

        dataViewer.__grphdrExtInfo = function (fld, val, fldDisp, valDisp, rs) {
            //return fld + " ==> " + rs.length;
            var totalReceivable = 0.0,
                totalArrival = 0.0,
                totalUnarrival = 0.0,
                n = 0;

            //for (i = 0; i < rs.length; i++) {
            var fullRs = dataViewer.itemsSource.sourceCollection;

            for (i = 0; i < fullRs.length; i++) {
                if (fullRs[i][fld] != val)
                    continue;
                totalReceivable += (fullRs[i].receivable == null ? 0 : eval(fullRs[i].receivable));
                if (fullRs[i].arrival != null)
                    totalArrival += eval(fullRs[i].arrival);
                else totalUnarrival += 1;
                n += 1;
            }
            if (level >= 2)
                return "<span>" + fldDisp + "：" + valDisp + " (" + n + " 项目)</span>";
            if (valDisp == "")
                valDisp = "未知" + fldDisp;
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

        $("#pagingInput").on('blur', function () {
            dataViewer.itemsSource.pageSize = wijmo.Globalize.parseInt(
                this.value == "" ? "0" : this.value);
            //session.pageSize = dataViewer.itemsSource.pageSize;
            updateNaviagteButtons();
            $("#saveLayout").show();
        });


        // commands: moving page.
        btnFirstPage.addEventListener('click', function () {
            // move to the first page.
            dataViewer.itemsSource.moveToFirstPage();
            updateNaviagteButtons();
        });

        btnPreviousPage.addEventListener('click', function () {
            // move to the previous page.
            dataViewer.itemsSource.moveToPreviousPage();
            updateNaviagteButtons();
        });

        btnNextPage.addEventListener('click', function () {
            // move to the next page.
            dataViewer.itemsSource.moveToNextPage();
            updateNaviagteButtons();
        });

        btnLastPage.addEventListener('click', function () {
            // move to the last page.
            dataViewer.itemsSource.moveToLastPage();
            updateNaviagteButtons();
        });

        mnGroup = new wijmo.input.Menu('#groupMenu');
        mnGroup.itemClicked.addHandler(function(sender, args){
            var menu = sender;
            //alert('Thanks for selecting option ' + menu.selectedIndex + ' from menu **' + menu.header + '**!');
            //alert(JSON.stringify(menu));
            //throw 'err';
            //menu.header = "<span class='glyphicon glyphicon-search'></span> <b>分组显示：</b>" + grpDescs[menu.selectedIndex].disp;
            updateGroupInfo(menu.selectedIndex);
            $("#saveLayout").show();
            //cv.groupDescriptions.clear();
            //if (grpDescs[menu.selectedIndex].field == "no")
            //    return;
            //cv.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription(grpDescs[menu.selectedIndex].field));
            //dataViewer.collapseGroupsToLevel(foldLevel);
        });
        //$("#saveBizdata").attr("disabled", level >= 2);
        //updateNaviagteButtons();
        if (level > 2)
            $("#saveBizdata").hide();

        $("#saveLayout").hide();
    });
</script>
