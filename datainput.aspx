
<%@ Page Language="C#" %>

<div class="container">
    <ul class="nav nav-tabs">
        <li><a data-toggle="tab" href="#home"><span class="glyphicon glyphicon-file"></span> 文件录入</a></li>
        <li class="active"><a data-toggle="tab" href="#menu1"><span class="glyphicon glyphicon-text-size"></span> 段落录入</a></li>
        <li><a data-toggle="tab" href="#menu2"><span class="glyphicon glyphicon-bookmark"></span> 帮助</a></li>
    </ul>
    <div class="tab-content">
        <div id="home" class="tab-pane fade">
            <h2>Help text</h2>
            <p>Use the .help-block class to add a block level help text in forms:</p>
            <form role="form">
                <div class="form-group">
                    <label for="pwd">Password:</label>
                    <input type="password" class="form-control" id="pwd" placeholder="Enter password">
                    <span class="help-block">This is some help text that breaks onto a new line and may extend more than one line.</span>
                </div>
                <button type="submit" class="btn btn-default">Submit</button>
            </form>

        </div>
        <div id="menu1" class="tab-pane fade in active">
            <h2>通过文本直接录入业务数据</h2>
            <p>你可以从已经打开的WORD文档中或者其他任何地方，拷贝一段完整的业务数据进行录入。<br />系统会尽可能按已有规则对您所输入的数据进行
                解析，如果系统自动解析的数据不正确，你还可以对系统解析出来的数据进行手动修改，待数据修正完备后，再提交系统保存。</p>
            <p>例如：“XXX：本院受理XXX诉你XXX一案，并定于2015年3月30日上午10：30在XXX公开开庭审理。XXX人民法院”。 
                <span class="glyphicon glyphicon-info-sign"></span><a href="#" onclick="new function(){$('#bizDataSample').modal();}"> 点击查看示例 ...</a></p>
            <form role="form" id="frmParagrahInput">
                <div class="form-group">
                    <textarea class="form-control" rows="7" id="paragraphText" name="paragraphText"></textarea>
                    <span class="help-block" id="paragraphInfo"></span>
                </div>
                <button type="button" id="submitParagraph" class="btn btn-primary"> 提交系统解析</button>
                <button type="reset" class="btn btn-default"> 清 空</button>
            </form>
        </div>
        <div id="menu2" class="tab-pane fade">
            <h2>Peter Griffin, Bass player</h2>
            <p>I mean, sometimes I enjoy the show, but other times I enjoy other things.</p>
        </div>
    </div>
</div>
<div class="container">
    <p></p>
    <div id="dataViewer" class="panel panel-primary"></div>
    <button type="button" id="submitBizdata" class="btn btn-success btn-lg">
        <span class="glyphicon glyphicon-floppy-saved"></span> 提交系统保存</button>
</div>

<script>
    $(document).ready(function () {
        $("#submitParagraph").click(function () {
            //alert("xx");
            //var count = 100;
            //var jdata = [];

            //for (var i = 0; i < 100 ; i++) {
            //    jdata.push({
            //        No: "00" + (i + 1).toString(),
            //        ID: "21601" + i.toString(),
            //        EngName: "TingTao Ge",
            //        ChnName: "听涛阁",
            //        MinFloor: 2,
            //        MaxFloor: 12,
            //        State: true,
            //        Date: new Date(2014, i % 12, i % 28),
            //    });
            //}

            //var person = [{
            //    name: "Blues",
            //    age:37,
            //    address: "Malianwa North Rd.",
            //    phone: "18610067758"
            //}, {
            //    name: "Candy",
            //    address: "Malianwa North Rd.",
            //    phone: "18610067758",
            //    age:10
            //}];
            //$("#btk_ok").bind('click', function () {
            //alert($("#form1").serialize());
            //$("#proc_info").html("");
            //$("#proc_status").html("committing data ...");
            $("#submitParagraph").attr("disabled", true);
            $("#paragraphInfo").html("正在向系统提交数据，共 " + $("#paragraphText").val().length + " 字符。");

            var pb_timer = setInterval(function () {
                var text = "";
                $.ajax({
                    type: 'post',
                    url: 'DataParser.aspx',
                    data: "get_status=true",
                    cache: false,
                    dataType: 'json',
                    success: function (data) {
                        text = data.number + " of " + data.total + " processed, " + data.error + " errors";
                        if (data.number > 0 && eval(data.number) + eval(data.error) == eval(data.total)) {
                            clearInterval(pb_timer);
                            text += " done!";
                            $("#submitParagraph").attr("disabled", false);
                        } else text += ", please wait for a moment ...";
                        $("#paragraphInfo").html(text);
                    },
                    error: function (o, message) {
                        $("#paragraphInfo").html(message);
                    }
                });
            }, 600);

            $.ajax({
                type: 'post',
                url: 'DataParser.aspx',
                //data: "data=" + JSON.stringify(person), //$("#form1").serialize(),
                data: $("#frmParagrahInput").serialize(),
                cache: false,
                dataType: 'json',
                success: function (data) {
                    //alert('return data len' + data.len);
                    //var text = "<b>Total " + data.records.length + " records.</b><br><table border=1>";
                    ////alert(data.count + ", records:" + data.records.length);
                    //var count = data.records.length;
                    //for (i = 0; i < count; i++) {
                    //    //alert(data.records[i].accused);
                    //    var item = data.records[i];
                    //    var para = item.para;
                    //    /*
                    //    text += "<tr>";
                    //    text += "<td colspan=9>[" + para.begin + "," + para.end + "]" + para.text + "</td>";
                    //    text += "</tr>";

                    //    if (data.records[i].status == 0) {
                    //        color = "#c5ede8";
                    //        if (data.records[i].accused == ""
                    //            || data.records[i].accuser == "")
                    //            color = "#ffff00";
                    //    } else if (data.records[i].status == 2)
                    //        color = "#808080";
                    //    else color = "#ff0000"

                    //    text += "<tr style=\"background-color:" + color + "\">";
                    //    text += "<td>" + data.records[i].type + "</td>";
                    //    text += "<td>" + data.records[i].accused + "</td>";
                    //    text += "<td>" + data.records[i].accuser + "</td>";
                    //    text += "<td>" + data.records[i].court + "</td>";
                    //    text += "<td>" + data.records[i].courtroom + "</td>";
                    //    text += "<td>" + data.records[i].telephone + "</td>";
                    //    text += "<td>" + data.records[i].title + "</td>";
                    //    text += "<td>" + data.records[i].status + "</td>";
                    //    text += "<td>" + data.records[i].message + "</td>";
                    //    text += "</tr>";*/
                    //    parse_records.push({
                    //        "业务类型": item.type,
                    //        "accused": item.accused,
                    //        "accuser": item.accuser,
                    //        "court": item.court,
                    //        "courtroom": item.courtroom,
                    //        "telephone": item.telephone,
                    //        "title": item.title,
                    //        "status": item.status,
                    //        "message": item.message,
                    //    });
                    //}
                    ////////text += "</table>"
                    ////////$("#proc_info").html(text);

                    var cv = new wijmo.collections.CollectionView(data.records);
                    dataViewer.itemsSource = cv;
                    //dataViewer.itemsSource.pageSize = 20;
                    //dataViewer.itemsSource.moveToNextPage();
                    //dataViewer.itemsSource.pageIndex = 3;
                    //alert("ok");
                    //cv.currentChanged.addHandler(function (sender, args) {
                    //    //alert("cv.currentItem = " + cv.currentItem.para.text);
                    //    //$("#bottomTip").show(500);
                    //    alert(cv.currentItem.para.text);
                    //    $("#bottomTip").html(cv.currentItem.para.text);
                    //});
                    cv.currentChanged.addHandler(zzzzzzzzz);
                },
                error: function (o, message) {
                    alert(message);
                }
            });
        });

        function zzzzzzzzz(sender, args) {
            //alert("cv.currentItem = " + cv.currentItem.para.text);
            //$("#bottomTip").show(500);
            //alert("cv.currentItem.para.text");
            $("#bottomTip").html(dataViewer.itemsSource.currentItem.para.text);
        }

        $("#submitBizdata").click(function () {
            //var person = [{
            //    name: "Blues",
            //    age:37,
            //    address: "Malianwa North Rd中文.",
            //    phone: "18610067758"
            //}, {
            //    name: "Candy",
            //    address: "苗伟：本院受理原告张育升诉你民间借贷纠纷一案，因你下落不明，现依法向你公告送达起诉书副本、应诉通知书、举证通知书及开庭传票。自公告之日起经过60日即视为送达。提交答辩状和举证期限均为公告期满后的15日内。并定于2015年3月30日下午2：30在本院横岗法庭第三审判庭公开开庭审理，无正当理由拒不到庭的，本院将作出缺席判决。 ",
            //    phone: "18610067758",
            //    age:10
            //}];

            $.ajax({
                type: 'post',
                url: 'DataSave.aspx',
                data: "op=new&data=" + JSON.stringify(dataViewer.itemsSource.items), //$("#form1").serialize(),
                //data: "op=new&data=" + JSON.stringify(person), //$("#form1").serialize(),
                //data: $("#frmParagrahInput").serialize(),
                cache: false,
                dataType: 'json',
                success: function (data) {
                    if (eval(data.status) == 0) {
                        dataViewer.itemsSource = null;
                        $("#msgboxTitle").html("<span class=\"glyphicon glyphicon-ok\"/> 业务数据保存成功");
                        $("#msgboxBody").html("总共成功保存 " + data.successNum + " 条业务数据。[message: " + data.message + "]");
                        $("#msgbox").modal();
                    }
                },
                error: function (o, message) {
                    alert(message);
                }
            });
        });

        //$("#paragraphText").onchange(function () {
        $("#paragraphText").on('keyup', function () {
            $("#paragraphInfo").html("共 " + $("#paragraphText").val().length + " 字符。");
        });

        $(document).on('mousedown', function (e) {
            if (dataViewer.itemsSource == null)
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

        dataViewer = new wijmo.grid.FlexGrid('#dataViewer', {
            showSelectedHeaders: 'All',
            itemsSource: null
            //new wijmo.odata.ODataCollectionView(
            //'http://services.odata.org/V4/Northwind/Northwind.svc/',
            //'Order_Details_Extendeds'),
        });

        dataViewerFilter = new wijmo.grid.filter.FlexGridFilter(dataViewer);
    });
</script>