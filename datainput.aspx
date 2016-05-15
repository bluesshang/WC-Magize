
<%@ Page Language="C#" %>

<div class="container">
    <ul class="nav nav-tabs">
        <li><a data-toggle="tab" href="#home"><span class="glyphicon glyphicon-file"></span> �ļ�¼��</a></li>
        <li class="active"><a data-toggle="tab" href="#menu1"><span class="glyphicon glyphicon-text-size"></span> ����¼��</a></li>
        <li><a data-toggle="tab" href="#menu2"><span class="glyphicon glyphicon-bookmark"></span> ����</a></li>
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
            <h2>ͨ���ı�ֱ��¼��ҵ������</h2>
            <p>����Դ��Ѿ��򿪵�WORD�ĵ��л��������κεط�������һ��������ҵ�����ݽ���¼�롣<br />ϵͳ�ᾡ���ܰ����й����������������ݽ���
                ���������ϵͳ�Զ����������ݲ���ȷ���㻹���Զ�ϵͳ�������������ݽ����ֶ��޸ģ������������걸�����ύϵͳ���档</p>
            <p>���磺��XXX����Ժ����XXX����XXXһ����������2015��3��30������10��30��XXX������ͥ����XXX����Ժ���� 
                <span class="glyphicon glyphicon-info-sign"></span><a href="#" onclick="new function(){$('#bizDataSample').modal();}"> ����鿴ʾ�� ...</a></p>
            <form role="form" id="frmParagrahInput">
                <div class="form-group">
                    <textarea class="form-control" rows="7" id="paragraphText" name="paragraphText"></textarea>
                    <span class="help-block" id="paragraphInfo"></span>
                </div>
                <button type="button" id="submitParagraph" class="btn btn-primary"> �ύϵͳ����</button>
                <button type="reset" class="btn btn-default"> �� ��</button>
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
        <span class="glyphicon glyphicon-floppy-saved"></span> �ύϵͳ����</button>
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
            //        ChnName: "���θ�",
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
            $("#paragraphInfo").html("������ϵͳ�ύ���ݣ��� " + $("#paragraphText").val().length + " �ַ���");

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
                    //        "ҵ������": item.type,
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
            //    address: "Malianwa North Rd����.",
            //    phone: "18610067758"
            //}, {
            //    name: "Candy",
            //    address: "��ΰ����Ժ����ԭ���������������������һ�����������䲻�������������㹫���ʹ������鸱����Ӧ��֪ͨ�顢��֤֪ͨ�鼰��ͥ��Ʊ���Թ���֮���𾭹�60�ռ���Ϊ�ʹ�ύ���״�;�֤���޾�Ϊ�����������15���ڡ�������2015��3��30������2��30�ڱ�Ժ��ڷ�ͥ��������ͥ������ͥ�������������ɾܲ���ͥ�ģ���Ժ������ȱϯ�о��� ",
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
                        $("#msgboxTitle").html("<span class=\"glyphicon glyphicon-ok\"/> ҵ�����ݱ���ɹ�");
                        $("#msgboxBody").html("�ܹ��ɹ����� " + data.successNum + " ��ҵ�����ݡ�[message: " + data.message + "]");
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
            $("#paragraphInfo").html("�� " + $("#paragraphText").val().length + " �ַ���");
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