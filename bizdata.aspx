<%@ Page Language="C#" %>

<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Web.UI" %>

<%
    if (Application["userId"] == null)
    {
        Response.Redirect("index.aspx", true);
    }
%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>文萃报刊信息登记管理系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="author" content="Blues Shang (blues.shang@yahoo.com)">
    <link rel="shortcut icon" href="images/icon.jpg" type="image/x-icon" />

    <link rel="stylesheet" href="css/bootstrap-3.3.6.css">
    <script src="js/jquery-2.0.0.js"></script>
    <script src="js/bootstrap-3.3.6.js"></script>

    <!--Theme-->
    <!--link hrefxx="http://cdn.wijmo.com/themes/aristo/jquery-wijmo.cssxxx" rel="stylesheet" type="text/css" /-->

    <!--Wijmo Widgets CSS-->
    <!--link href="http://cdn.wijmo.com/jquery.wijmo-pro.all.3.20132.15.min.cssxxx" rel="stylesheet" type="text/css" /-->

    <!-- Material Lite -->
    <!--link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons" /-->
    <!--link rel="stylesheet" href="https://code.getmdl.io/1.1.1/material.indigo-red.min.css" /-->
    <!--link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:regular,bold,italic,thin,light,bolditalic,black,medium&amp;lang=en" /-->
    <!--script defer src="https://code.getmdl.io/1.1.1/material.min.js"></script-->

    <!-- Syntax Highlighter -->
    <!-- <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.1.0/styles/default.min.css"> -->
    <!--link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.1.0/styles/github.min.css"-->
    <!--script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.1.0/highlight.min.js"></script-->

    <!-- Wijmo -->
    <link href="css/wijmo.min.css" rel="stylesheet" />
    <link href="css/wijmo.theme.material.min.css" rel="stylesheet" />
    <!--link href="css/wijmo.theme.cocoa.min.css" rel="stylesheet" /-->

    <script src="js/wijmo.min.js"></script>
    <script src="js/wijmo.input.min.js"></script>
    <script src="js/wijmo.grid.min.js"></script>
    <script src="js/wijmo.grid.filter.min.js"></script>
    <script src="js/wijmo.chart.min.js"></script>
    <script src="js/wijmo.xlsx.min.js"></script>
    <script src="js/wijmo.grid.xlsx.min.js"></script>
    <script src="js/wijmo.odata.min.js"></script>
    <script src="js/wijmo.olap.min.js"></script>

    <!--link href="http://cdn.wijmo.com/themes/aristo/jquery-wijmo.css" rel="stylesheet" type="text/css" />
			<link href="http://cdn.wijmo.com/jquery.wijmo-pro.all.3.20132.15.min.css" rel="stylesheet" type="text/css" />
			<script src="http://code.jquery.com/ui/1.10.1/jquery-ui.min.js" type="text/javascript"></script>
			<script src="http://cdn.wijmo.com/jquery.wijmo-open.all.3.20132.15.min.js" type="text/javascript"></script>
			<script src="http://cdn.wijmo.com/jquery.wijmo-pro.all.3.20132.15.min.js" type="text/javascript"></script-->

    <script src="js/wijmo.culture.zh.js"></script>

    <link rel="stylesheet" href="css/app.css">
    <script src="js/app.js"></script>

    <style>
  </style>

</head>

<body style="margin-top: 95px;">
    <nav class="navbar navbar-default navbar-fixed-top">
        <div class="container-fluid">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">
                    <img src="images/log-small.jpg"></a>
            </div>
            <div class="collapse navbar-collapse" id="myNavbar">
                <ul class="nav navbar-nav navbar-right">
                    <li><a href="#" id="search"><span class="glyphicon glyphicon-search"></span></a></li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <span class="glyphicon glyphicon glyphicon-star"></span> Theme(material) <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a href="#">default</a></li>
                            <li><a href="#">material</a></li>
                            <li><a href="#">grayscale</a></li>
                            <li><a href="#">cocoa</a></li>
                            <li><a href="#">...</a></li>
                        </ul>
                    </li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <span class="glyphicon glyphicon-user"></span> <%=Application["userFullName"] + "(" + Application["userName"] + ")" %> <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a href="#">修改密码</a></li>
                            <li><a href="#">修改个人信息</a></li>
                            <li><a href="#">...</a></li>
                        </ul>
                    </li>
                    <li><a href="do.aspx?op=logout"><span class="glyphicon glyphicon-log-out"></span> 退出系统 </a></li>
                </ul>
            </div>
        </div>
    </nav>

    <nav class="navbar navbar-defaultx navbar-fixed-bottom bottom-tip" id="bottomTipCtrl">
        <div id="bottomTip" style="margin-left:100px;margin-top:10px;margin-right:10px;margin-bottom:10px"></div>
    </nav>

    <table border="0" style="width:100%">
        <tr>
            <td style="width: 25%; min-width: 300px; max-width: 500px; margin-left: 5px; vertical-align: top;">
                <div style="padding-right: 15px; padding-left: 15px; margin-right: auto; margin-left: auto;">
                    <!--h2>Accordion Example</!--h2>
                    <p><strong>Note:</strong> The <strong>data-parent</strong> attribute makes sure that all collapsible elements under the specified parent will be closed when one of the collapsible item is shown.</p-->
                    <div class="panel-group" id="accordion">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapse1">业务数据录入</a>
                                </h4>
                            </div>
                            <div id="collapse1" class="panel-collapse collapse in">
                                <div class="list-group">
                                    <a href="#" class="list-group-item " id="batchInput">
                                        <span class="badge btn-success" title="今日录入业务" id="today"></span>
                                        <h4 class="list-group-item-heading">批量录入</h4>
                                        <p class="list-group-item-text">通过文件的方式，系统会尽可能解析文件中的业务数据，一次性录入多条记录。</p>
                                    </a>
                                    <a href="#" class="list-group-item">
                                        <h4 class="list-group-item-heading">单条录入</h4>
                                        <p class="list-group-item-text">List Group Item Text</p>
                                    </a>
                                    <a href="#" class="list-group-item" id="dataView">
                                        <span class="badge btn-danger" title="未到帐业务" id="unarrival"></span>
                                        <h4 class="list-group-item-heading">查看已录入系统的数据</h4>
                                        <p class="list-group-item-text">List Group Item Text</p>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapse2">业务统计</a>
                                </h4>
                            </div>
                            <div id="collapse2" class="panel-collapse collapse">
                                <div class="panel-body">
                                    Lorem ipsum dolor sit amet, consectetur adipisicing elit,
			        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
			        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
                                </div>
                                <div class="panel-body">
                                    Lorem ipsum dolor sit amet, consectetur adipisicing elit,
			        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
			        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
                                </div>
                                <div class="panel-body">
                                    Lorem ipsum dolor sit amet, consectetur adipisicing elit,
			        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
			        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
                                </div>
                                <div class="panel-body">
                                    Lorem ipsum dolor sit amet, consectetur adipisicing elit,
			        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
			        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
                                </div>
                                <div class="panel-body">
                                    Lorem ipsum dolor sit amet, consectetur adipisicing elit,
			        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
			        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
                                </div>
                            </div>
                        </div>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <span class="glyphicon glyphicon-cog"></span>
                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapse3">系统维护</a>
                                </h4>
                            </div>
                            <div id="collapse3" class="panel-collapse collapse">
                                <div class="panel-body">对系统的运行参数进行调整和用户进行管理.</div>
                            </div>
                        </div>
                    </div>
                    <div id="bizChart" style="height:250px;width:100%"></div>
                    <div id="bizChartRecords" style="height:200px;width:100%"></div>
                </div>
            </td>
            <td style="vertical-align: top;padding-bottom:100px">
                <div id="mainClientArea">


                </div>
                <hr />
                <p align="center" style="margin-top:30px">(c)2016 WenCui Magazine. <span class="glyphicon glyphicon-envelope"></span> blues.shang@yahoo.com </p> 
            </td>
        </tr>
    </table>

    <div class="container">
        <div class="modal fade" id="myLoginModal" role="dialog">
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header" style="padding: 35px 50px;">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4><span class="glyphicon glyphicon-lock"></span>请输入系统登录信息</h4>
                    </div>
                    <div class="modal-body" style="padding: 40px 50px;">
                        <form role="form">
                            <div class="form-group">
                                <label for="usrname"><span class="glyphicon glyphicon-user"></span>Username</label>
                                <input type="text" class="form-control" id="usrname" placeholder="请输入你的系统帐号">
                            </div>
                            <div class="form-group">
                                <label for="psw"><span class="glyphicon glyphicon-eye-open"></span>Password</label>
                                <input type="password" class="form-control" id="psw" placeholder="Enter password">
                            </div>
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox" value="" checked>Remember me</label>
                            </div>
                            <button type="submit" class="btn btn-success btn-block"><span class="glyphicon glyphicon-off"></span>Login</button>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <p class="pull-left">会话超时，请重新登录。</p>
                        <p>Not a member? <a href="#">Sign Up</a></p>
                        <p>Forgot <a href="#">Password?</a></p>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- Modal -->
    <div id="bizDataSample" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">“开庭”业务数据示例</h4>
                </div>
                <div class="modal-body">
                    <p>
                        苗伟：本院受理原告张育升诉你民间借贷纠纷一案，因你下落不明，现依法向你公告送达起诉书副本、应诉通知书、举证通知书及开庭传票。自公告之日起经过60日即视为送达。提交答辩状和举证期限均为公告期满后的15日内。并定于2015年3月30日下午2：30在本院横岗法庭第三审判庭公开开庭审理，无正当理由拒不到庭的，本院将作出缺席判决。
					<br>
                        广东省深圳市龙岗区人民法院
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>

        </div>
    </div>

    <div id="msgbox" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" id="msgboxTitle">Title</h4>
                </div>
                <div class="modal-body" id="msgboxBody">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        var bizChart = null, bizChartRecords = null;

        function refreshRealtimeInfo() {
            var text = "";
            $.ajax({
                type: 'post',
                url: 'do.aspx',
                data: "op=rtinfo",
                cache: false,
                dataType: 'json',
                success: function (data) {
                    var ms = [];
                    for (i = 0; i < data.monthStat.length; i++) {
                        ms.push({
                            monthId : data.monthStat[i].month,
                            month: data.monthStat[i].month + "月",
                            receivable: parseFloat(data.monthStat[i].receivable),
                            arrival: parseFloat(data.monthStat[i].arrival),
                            records: parseInt(data.monthStat[i].records)
                        });
                    }
                    bizChart.itemsSource = new wijmo.collections.CollectionView(ms);
                    bizChartRecords.itemsSource = bizChart.itemsSource;
                    //text = data.number + " of " + data.total + " processed, " + data.error + " errors";
                    //if (data.number > 0 && eval(data.number) + eval(data.error) == eval(data.total)) {
                    //    clearInterval(rti_timer);
                    //    text += " done!";
                    //    $("#submitParagraph").attr("disabled", false);
                    //} else text += ", please wait for a moment ...";
                    //$("#paragraphInfo").html(text);
                    if (eval(data.unarrivals.records) > 0)
                        $("#unarrival").html(data.unarrivals.records + " , ¥ " + data.unarrivals.amount);
                    else $("#unarrival").html("");

                    if (eval(data.today.records) > 0)
                        $("#today").html(data.today.records);
                    else $("#today").html("");
                },
                error: function (o, message) {
                    //$("#paragraphInfo").html(message);
                }
            });
        }

        $(document).ready(function () {

            $("#search").click(function () {
                $("#mainClientArea").load("search.aspx");
            });

            $("#batchInput").click(function () {
                $("#mainClientArea").load("datainput.aspx");
            });

            $("#dataView").click(function () {
                $("#mainClientArea").load("dataview.aspx");
            });

            $("#myLoginBtn").click(function () {
                $("#myLoginModal").modal();
            });

            $(document).on('mousedown', function (e) {
                if (dataViewer == null || dataViewer.itemsSource == null || dataViewer.itemsSource.items.length < 2
                    || e.toElement.id == "bottomTipCtrl"
                    || e.toElement.id == "bottomTip")
                    return;

                var t = $("#dataViewer").offset().top;
                var l = $("#dataViewer").offset().left;
                //var box = $("dataViewer").getBoundingClientRect();
                var w = $("#dataViewer").width();
                var h = $("#dataViewer").height();
                //var content_div = document.getElementById("dataViewer");
                //var rc = content_div.style.left;
                //$("#bottomTip").html("x = " + e.pageX
                //    + ", y=" + e.pageY
                //    + ", top=" + t
                //    + ", left=" + l
                //    + ", width=" + w
                //    + ", height=" + h
                //    + ", scroll=" + document.body.scrollTop
                //    );
                //+ ",body.scrollLeft=" + document.body.scrollLeft
                //+ ",body.scrollTop=" + document.body.scrollTop
                //+ ", div rc.left=" + rc
                //+ ",bottom=" + content_div.style.bottom);
                //if (e.clientY + document.body.scrollTop < 500)
                //$("#bottomTip").html(dataViewer.itemsSource.currentItem.para.text);

                if (e.pageY > t && e.pageY < t + h && e.pageX > l && e.pageX < l + w)
                    $("#bottomTipCtrl").show();
                else $("#bottomTipCtrl").hide();
            });

            //// $('[data-toggle="popover"]').popover();  
            //{
            //    var count = 100;
            //    var data = [];

            //    for (var i = 0; i < count ; i++) {
            //        data.push({
            //            序号: "00" + (i + 1).toString(),
            //            ID号: "21601" + i.toString(),
            //            英文名: "TingTao Ge",
            //            中文名: "听涛阁",
            //            最小楼层: 2,
            //            最大楼层: 12,
            //            状态: true,
            //            日期: new Date(2014, i % 12, i % 28),
            //        });
            //    }
            //    var cv = new wijmo.collections.CollectionView(data);

            //    dataViewer = new wijmo.grid.FlexGrid('#dataViewer', {
            //        showSelectedHeaders: 'All',
            //        itemsSource: cv
            //        //new wijmo.odata.ODataCollectionView(
            //        //'http://services.odata.org/V4/Northwind/Northwind.svc/',
            //        //'Order_Details_Extendeds'),
            //    });

            //    dataViewerFilter = new wijmo.grid.filter.FlexGridFilter(dataViewer);
            //}

            /*$("#wijeditor").wijeditor({
                editorMode: "split",
                mode: "simple",
                //simpleModeCommands: ["Bold", "Italic", "Link", "BlockQuote", "StrikeThrough", "InsertDate", "InsertImage", "NumberedList", "BulletedList", "InsertCode"]
                simpleModeCommands: ["Bold", "Italic", "FontName", "FontSize", "InsertImage", "NumberedList", "BulletedList", "Undo"]
            });    */

            $("#mainClientArea").load("datainput.aspx");
            $("#bottomTipCtrl").hide();

            bizChart = new wijmo.chart.FlexChart('#bizChart', {
                itemsSource: null,
                legend: { position: wijmo.chart.Position.Bottom },
                bindingX: 'month',
                series: [{
                    binding: 'receivable',
                    name: '应收帐款'
                }, {
                    binding: 'arrival',
                    name: '实收帐款'
                }],
                selectionMode: wijmo.chart.SelectionMode.Point,
                selectionChanged: function (e) {
                    $("#mainClientArea").load("dataview.aspx?month=" + bizChart.selection.collectionView.currentItem.monthId);
                }
            });

            bizChartRecords = new wijmo.chart.FlexChart('#bizChartRecords', {
                itemsSource: null,
                legend: { position: wijmo.chart.Position.Bottom },
                bindingX: 'month',
                series: [{
                    binding: 'records',
                    name: '业务量',
                    chartType: wijmo.chart.ChartType.LineSymbols
                }],
                selectionMode: wijmo.chart.SelectionMode.Point,
                selectionChanged: function (e) {
                    $("#mainClientArea").load("dataview.aspx?month=" + bizChartRecords.selection.collectionView.currentItem.monthId);
                }
            });

            refreshRealtimeInfo();

            var rti_timer = setInterval(refreshRealtimeInfo, 3000);

            //bizChartRecords.addEventListener('click', function () {
            //    alert("xx");
            //});
            //{
            //    // create some random data
            //    var countries = 'US,Germany,UK,Japan,Italy,Greece'.split(','),
            //        data = [];
            //    for (var i = 0; i < countries.length; i++) {
            //        data.push({
            //            country: countries[i],
            //            downloads: Math.round(Math.random() * 20000),
            //            sales: Math.random() * 10000,
            //            expenses: Math.random() * 5000
            //        });
            //    }

            //    // create CollectionView on the data (to get events)
            //    var view = new wijmo.collections.CollectionView(data);
            //    // initialize the chart
            //    var chart = new wijmo.chart.FlexChart('#bizChart', {
            //        itemsSource: view,
            //        legend: { position: wijmo.chart.Position.Bottom },
            //        bindingX: 'country',
            //        series: [{
            //            binding: 'sales',
            //            name: 'Sales'
            //        }, {
            //            binding: 'expenses',
            //            name: 'Expenses'
            //        }, {
            //            binding: 'downloads',
            //            name: 'Downloads',
            //            chartType: wijmo.chart.ChartType.LineSymbols
            //        }],
            //        selectionMode: wijmo.chart.SelectionMode.Point
            //    });
            //}
        });
    </script>
</body>
</html>
