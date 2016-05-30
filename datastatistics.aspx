
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
    <h4><img src="images/statistics.png" width="70" height="70"/> ҵ��ͳ����Ϣ</h4>
    <table style="padding-bottom:10px;margin-bottom:10px">
        <tr>
            <td>
                <ul class="nav nav-pills nav-pills-ext">
                    <li data-toggle="pill"id="unfoldAll"><a href="#">չ������ͳ����</a></li>
                    <li data-toggle="pill" class="active"  id="foldAll"><a href="#">�۵�����ͳ����</a></li>
                    <li data-toggle="pill"id="noGroup"><a href="#">������ͳ��</a></li>
                </ul>
            </td>
            <td style="padding-right:40px">&nbsp;</td>
            <td>
                <ul class="nav nav-pills nav-pills-ext">
                    <li data-toggle="pill" id="byYear"><a href="#">����ͳ��</a></li>
                    <li data-toggle="pill" class="active" id="byDate"><a href="#">����ͳ��</a></li>
                    <li data-toggle="pill" id="byEmployee"><a href="#">��ҵ��Աͳ��</a></li>
                </ul>
            </td>
            <td>
            </td>
        </tr>
    </table>
    <div id="dataViewer"></div>
    <div id="summary" class="panel" style="padding-top:20px;border:0px"></div>
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
                    //$("#msgboxTitle").html("<span class=\"glyphicon glyphicon-ok\"/> ҵ�����ݱ���ɹ�");
                    //$("#msgboxBody").html("�ܹ��ɹ����� " + data.successNum + " ��ҵ�����ݡ�[message: " + data.message + "]");
                    //$("#msgbox").modal();
                    //var records = [];
                    //for (i = 0; i < data.records.length; i++) {
                    //    data.records[i].orders = eval(data.records[i].orders);
                    //    data.records[i].arrival = eval(data.records[i].arrival);
                    //    data.records[i].receivable = eval(data.records[i].receivable);
                    //}
                    evalDataStatistics(data.records);

                    var cv = new wijmo.collections.CollectionView(data.records);
                    //var cv = new wijmo.collections.CollectionView(records);
                    //cv.trackChanges = true;
                    dataViewer.itemsSource = cv;

                    //cv.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription("year"));
                    cv.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription("ym"));
                    dataViewer.collapseGroupsToLevel(0);

                    dataViewer.columns.getColumn('employee').dataMap = new wijmo.grid.DataMap(data.employees, "id", "name");

                    //cv.currentChanged.addHandler(function (sender, args) {
                    //    if (cv.currentItem != null)
                    //        $("#bottomTip").html(cv.currentItem.para.text);
                    //    //refreshModifyInfo(cv)
                    //});
                    $("#summary").html('<div class="alert alert-success" style="font-size:18px">'
                        + '  <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>'
                        + '  <strong>��ҵ��ͳ�ƣ�</strong> '
                        + 'ҵ������ <b>' + wijmo.Globalize.formatNumber(eval(data.summary.orders))
                        + '</b> �ʣ�Ӧ�տ <b>' + wijmo.Globalize.formatNumber(eval(data.summary.receivable), 'c')
                        + '</b>��ʵ�տ <b>' + wijmo.Globalize.formatNumber(eval(data.summary.arrival), 'c')
                        + '</b></div>');

                    //cv.pageSize = 10;
                    //updateNaviagteButtons();
                }
            },
            error: function (o, message, errInfos) {
                //alert(message + "\n" + errInfos.message + "\n" + errInfos.stack);
                //throw "too high";
                $("#msgboxTitle").html("<span class=\"glyphicon glyphicon-remove\"/> �������ִ���");
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
        //    $("#paragraphInfo").html("�� " + $("#paragraphText").val().length + " �ַ���");
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
                //{ header: '����', binding: 'type', width: 100 },
                //{ header: '�Ǳ�����', binding: 'publishTime', dataType: "Date"},
                //{ header: '����', binding: 'accused'},
                //{ header: 'ԭ��', binding: 'accuser'},
                //{ header: '��Ժ', binding: 'court'},
                //{ header: '��ͥ', binding: 'courtRoom'},
                //{ header: '����', binding: 'judge'},
                //{ header: '�绰', binding: 'telephone'},
                //{ header: '��Ʊ��', binding: 'invoiceNumber', visible: level <= 1 },
                //{ header: '��������', binding: 'magazine', isReadOnly: level != 0},
                //{ header: '��Ժ��ַ', binding: 'courtAddress'},
                //{ header: '����', binding: 'magazinePage'},
                { header: 'ʱ��', binding: 'ym' },
                { header: '��', binding: 'year', visible: false },
                { header: 'ҵ��Ա', binding: 'employee', width: 200},
                //{ header: '��������', binding: 'title', isReadOnly: lockField },
                //{ header: '¼������', binding: 'date', dataType: "Date", isReadOnly: true },
                { header: 'ҵ����', binding: 'orders', dataType: "Number"},
                { header: 'Ӧ�ս��', binding: 'receivable', dataType: "Number", format: 'c'},
                { header: 'ʵ�ս��', binding: 'arrival', dataType: "Number", format: 'c' },
                // { header: '��������', binding: 'arrivalTime', dataType: "Date", isReadOnly: true, visible: level <= 1 },
                //{ header: '����;��', binding: 'arrivalFrom', visible: level <= 1 },
                //{ header: '״̬', binding: 'status', width: '*', isReadOnly: true },
                //{ header: '��ע', binding: 'remark'}
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

        $("#byYear").click(function () {
            dataViewer.itemsSource.groupDescriptions.clear();
            dataViewer.itemsSource.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription("year"));
            dataViewer.itemsSource.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription("ym"));
            dataViewer.collapseGroupsToLevel(0);
        });
        $("#byDate").click(function () {
            dataViewer.itemsSource.groupDescriptions.clear();
            dataViewer.itemsSource.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription("ym"));
            dataViewer.collapseGroupsToLevel(0);
        });
        $("#byEmployee").click(function () {
            dataViewer.itemsSource.groupDescriptions.clear();
            dataViewer.itemsSource.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription("employee"));
            dataViewer.collapseGroupsToLevel(0);
        });

        $("#unfoldAll").click(function () {
            dataViewer.collapseGroupsToLevel(2);
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
                //totalUnarrival = 0.0,
                n = 0;

            //for (i = 0; i < rs.length; i++) {
            //var fullRs = dataViewer.itemsSource.sourceCollection;

            for (i = 0; i < rs.length; i++) {
                totalReceivable += (rs[i].receivable == null ? 0 : eval(rs[i].receivable));
                if (rs[i].arrival != null)
                    totalArrival += eval(rs[i].arrival);
                //else totalUnarrival += 1;
                n += 1;
            }

            return "<span>" + valDisp + " (" + n + " ����¼, Ӧ���ʿ�ƣ� " + wijmo.Globalize.formatNumber(totalReceivable, 'c')
                + "��ʵ�գ� " + wijmo.Globalize.formatNumber(totalArrival, 'c') 
                + ")"
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
