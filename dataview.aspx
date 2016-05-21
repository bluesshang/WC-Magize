
<%@ Page Language="C#" %>
<%@ import namespace="System" %>
<%@ import namespace="System.Web.UI" %>

<div class="container">
    <h2><span class="glyphicon glyphicon-edit"></span> 浏览、修改已录入的业务数据</h2>
    <span style="font-size:16px">选定需要查看的日期范围：从</span>
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
                    <li data-toggle="pill" class="active" id="viewYear"><a href="#">当年</a></li>
                    <li data-toggle="pill" id="viewMonth"><a href="#">当月</a></li>
                    <li data-toggle="pill" id="viewDay"><a href="#">当天</a></li>
                </ul>
            </td>
        </tr>
    </table>
</div>
<div class="container">
    <p></p>
    <!--div style="border:1px solid red"-->
    <div id="dataViewer" class="panel panel-primary"></div>
    <div id="modifyInfos"></div>
    <!--/div-->
    <button type="button" id="saveBizdata" class="btn btn-success btn-lg">
        <span class="glyphicon glyphicon-floppy-saved"></span> 保存修改
    </button>
</div>

<script>

    var foldLevel = 1, dateBegin = null, dateEnd = null;

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
                    var cv = new wijmo.collections.CollectionView(data.records);
                    cv.trackChanges = true;
                    dataViewer.itemsSource = cv;
                    cv.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription("employeeName"));
                    dataViewer.collapseGroupsToLevel(foldLevel);

                    cv.currentChanged.addHandler(function (sender, args) {
                        if (cv.currentItem != null)
                            $("#bottomTip").html(cv.currentItem.para.text);
                        if (cv.itemsEdited.length > 0 || cv.itemsRemoved.length > 0) {
                            $("#modifyInfos").html("<div class='alert alert-warning'><span class='glyphicon glyphicon-info-sign'></span> 修改记录：修改 " + cv.itemsEdited.length + " 条，删除 " + cv.itemsRemoved.length + " 条。</div>");
                            $("#saveBizdata").attr("disabled", false);
                        }
                    });
                }
            },
            error: function (o, message) {
                alert(message);
            }
        });
    }
    $(document).ready(function () {
        //var theDate = new Date();
        dateBegin = new wijmo.input.InputDate('#dateBegin', {
            //min: new Date(2014, 8, 1),
            format: 'yyyy-M-d',
            value: new Date(<%=DateTime.Now.Year%>, 0, 1)
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
        //$("#submitParagraph").click(function () {
        //    //alert("xx");
        //    //var count = 100;
        //    //var jdata = [];

        //    //for (var i = 0; i < 100 ; i++) {
        //    //    jdata.push({
        //    //        No: "00" + (i + 1).toString(),
        //    //        ID: "21601" + i.toString(),
        //    //        EngName: "TingTao Ge",
        //    //        ChnName: "听涛阁",
        //    //        MinFloor: 2,
        //    //        MaxFloor: 12,
        //    //        State: true,
        //    //        Date: new Date(2014, i % 12, i % 28),
        //    //    });
        //    //}

        //    //var person = [{
        //    //    name: "Blues",
        //    //    age:37,
        //    //    address: "Malianwa North Rd.",
        //    //    phone: "18610067758"
        //    //}, {
        //    //    name: "Candy",
        //    //    address: "Malianwa North Rd.",
        //    //    phone: "18610067758",
        //    //    age:10
        //    //}];
        //    //$("#btk_ok").bind('click', function () {
        //    //alert($("#form1").serialize());
        //    //$("#proc_info").html("");
        //    //$("#proc_status").html("committing data ...");
        //    //$("#submitParagraph").attr("disabled", true);
        //    //$("#paragraphInfo").html("正在向系统提交数据，共 " + $("#paragraphText").val().length + " 字符。");

        //    //var pb_timer = setInterval(function () {
        //    //    var text = "";
        //    //    $.ajax({
        //    //        type: 'post',
        //    //        url: 'DataParser.aspx',
        //    //        data: "get_status=true",
        //    //        cache: false,
        //    //        dataType: 'json',
        //    //        success: function (data) {
        //    //            text = data.number + " of " + data.total + " processed, " + data.error + " errors";
        //    //            if (data.number > 0 && eval(data.number) + eval(data.error) == eval(data.total)) {
        //    //                clearInterval(pb_timer);
        //    //                text += " done!";
        //    //                $("#submitParagraph").attr("disabled", false);
        //    //            } else text += ", please wait for a moment ...";
        //    //            $("#paragraphInfo").html(text);
        //    //        },
        //    //        error: function (o, message) {
        //    //            $("#paragraphInfo").html(message);
        //    //        }
        //    //    });
        //    //}, 600);

        //    $.ajax({
        //        type: 'post',
        //        url: 'DataParser.aspx',
        //        //data: "data=" + JSON.stringify(person), //$("#form1").serialize(),
        //        data: $("#frmParagrahInput").serialize(),
        //        cache: false,
        //        dataType: 'json',
        //        success: function (data) {
        //            //alert('return data len' + data.len);
        //            //var text = "<b>Total " + data.records.length + " records.</b><br><table border=1>";
        //            ////alert(data.count + ", records:" + data.records.length);
        //            //var count = data.records.length;
        //            //for (i = 0; i < count; i++) {
        //            //    //alert(data.records[i].accused);
        //            //    var item = data.records[i];
        //            //    var para = item.para;
        //            //    /*
        //            //    text += "<tr>";
        //            //    text += "<td colspan=9>[" + para.begin + "," + para.end + "]" + para.text + "</td>";
        //            //    text += "</tr>";

        //            //    if (data.records[i].status == 0) {
        //            //        color = "#c5ede8";
        //            //        if (data.records[i].accused == ""
        //            //            || data.records[i].accuser == "")
        //            //            color = "#ffff00";
        //            //    } else if (data.records[i].status == 2)
        //            //        color = "#808080";
        //            //    else color = "#ff0000"

        //            //    text += "<tr style=\"background-color:" + color + "\">";
        //            //    text += "<td>" + data.records[i].type + "</td>";
        //            //    text += "<td>" + data.records[i].accused + "</td>";
        //            //    text += "<td>" + data.records[i].accuser + "</td>";
        //            //    text += "<td>" + data.records[i].court + "</td>";
        //            //    text += "<td>" + data.records[i].courtroom + "</td>";
        //            //    text += "<td>" + data.records[i].telephone + "</td>";
        //            //    text += "<td>" + data.records[i].title + "</td>";
        //            //    text += "<td>" + data.records[i].status + "</td>";
        //            //    text += "<td>" + data.records[i].message + "</td>";
        //            //    text += "</tr>";*/
        //            //    parse_records.push({
        //            //        "业务类型": item.type,
        //            //        "accused": item.accused,
        //            //        "accuser": item.accuser,
        //            //        "court": item.court,
        //            //        "courtroom": item.courtroom,
        //            //        "telephone": item.telephone,
        //            //        "title": item.title,
        //            //        "status": item.status,
        //            //        "message": item.message,
        //            //    });
        //            //}
        //            ////////text += "</table>"
        //            ////////$("#proc_info").html(text);
        //            var cv = new wijmo.collections.CollectionView(data.records);
        //            dataViewer.itemsSource = cv;
        //            //dataViewer.itemsSource.pageSize = 20;
        //            //dataViewer.itemsSource.moveToNextPage();
        //            //dataViewer.itemsSource.pageIndex = 3;
        //            //alert("ok");
        //            cv.currentChanged.addHandler(function (sender, args) {
        //                //alert("cv.currentItem = " + cv.currentItem.para.text);
        //                //$("#bottomTip").show(500);
        //                //alert(cv.currentItem.para.text);
        //                $("#bottomTip").html(cv.currentItem.para.text);
        //            });
        //            //cv.currentChanged.addHandler(zzzzzzzzz);
        //        },
        //        error: function (o, message) {
        //            alert(message);
        //        }
        //    });
        //});

        //function zzzzzzzzz(sender, args) {
        //    //alert("cv.currentItem = " + cv.currentItem.para.text);
        //    //$("#bottomTip").show(500);
        //    //alert("cv.currentItem.para.text");
        //    $("#bottomTip").html(dataViewer.itemsSource.currentItem.para.text);
        //}
        $("#searchNow").click(function () {
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

        dataViewer = new wijmo.grid.FlexGrid('#dataViewer', {
            showSelectedHeaders: 'All',
            itemsSource: null,
            autoGenerateColumns: false,
            allowDelete: true,
            autoClipboard: true,
            showGroups: true,
            //autoSizeMode:true,
            //sortRowIndex:true,
            //allowAddNew: true,
            columns: [
                //{ header: '-', binding: 'valid', width: 30, format: 'b', dataType:"Boolean" },
                { header: '类型', binding: 'type', width: 100 },
                { header: '业务员', binding: 'employeeName', width: 100, isReadOnly: true },
                { header: '被告', binding: 'accused' },
                { header: '原告', binding: 'accuser' },
                { header: '法院', binding: 'court' },
                { header: '法庭', binding: 'courtRoom' },
                { header: '法官', binding: 'judge' },
                { header: '案件类型', binding: 'title' },
                { header: '电话', binding: 'telephone' },
                { header: '日期', binding: 'date', dataType: "Date", minWidth: 50, isReadOnly: true },
                { header: '应收金额', binding: 'receivable', dataType: "Number", format: 'c', minWidth: 20, maxWidth: 40 },
                { header: '实收金额', binding: 'arrival', dataType: "Number", format: 'c', minWidth: 20, maxWidth: 40 },
                { header: '到账日期', binding: 'arrivalTime', dataType: "Date", minWidth: 50, isReadOnly: true },
                //{ header: '状态', binding: 'status', width: '*', isReadOnly: true },
                { header: '备注', binding: 'remark'}
            ]
            //new wijmo.odata.ODataCollectionView(
            //'http://services.odata.org/V4/Northwind/Northwind.svc/',
            //'Order_Details_Extendeds'),
        });

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

        var typeMapping = new wijmo.grid.DataMap(bizTypes, "id", "name");
        dataViewer.columns.getColumn('type').dataMap = typeMapping;;
        dataViewer.__grphdrExtInfo = function (g, fld, rs) {
            //return fld + " ==> " + rs.length;
            var totalReceivable = 0.0,
                totalArrival = 0.0;
            for (i = 0; i < rs.length; i++) {
                totalReceivable += eval(rs[i].receivable);
                totalArrival += eval(rs[i].arrival);
            }
            return "<span> 应收帐款共计： "
                + g.Globalize.formatNumber(totalReceivable, 'c') + "，实收： "
                + g.Globalize.formatNumber(totalArrival, 'c') + "</span>";
        }

        dataViewerFilter = new wijmo.grid.filter.FlexGridFilter(dataViewer);

        queryNow();
    });
</script>
