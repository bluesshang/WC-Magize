
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
    <h2><span class="glyphicon glyphicon-edit"></span> ҵ�����ݴ���</h2>
    <span style="font-size:16px">ѡ����Ҫ�鿴�ĵǱ����ڷ�Χ����</span>
    <div id="dateBegin"></div>
    <span>��</span>
    <div id="dateEnd"></div>
    <button type="submit" class="btn btn-default" id="searchNow"><span class="glyphicon glyphicon-search"></span></button>
    <table>
        <tr>
            <td>
                <ul class="nav nav-pills nav-pills-ext">
                    <li data-toggle="pill" class="active" id="unfoldAll"><a href="#">չ������ͳ����</a></li>
                    <li data-toggle="pill" id="foldAll"><a href="#">�۵�����ͳ����</a></li>
                </ul>
            </td>
            <td>&nbsp;</td>
            <td>
                <ul class="nav nav-pills nav-pills-ext">
                    <li data-toggle="pill"id="viewYear"><a href="#">����</a></li>
                    <li data-toggle="pill" class="active"  id="viewMonth"><a href="#">����</a></li>
                    <li data-toggle="pill" id="viewDay"><a href="#">����</a></li>
                </ul>
            </td>
            <td>
            </td>
        </tr>
    </table>
</div>

<div class="container">
    <p></p>
    <div style="padding-bottom:10px">
        <table border="0" style="width:100%">
            <tr><td>
                <input id="pagingInput" type="text" class="form-control col-md-1" style="width:80px" placeholder="0 or empty is for no paging." value="10" />
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
        <span class="glyphicon glyphicon-floppy-saved"></span> �����޸�
    </button>
</div>

<script>
    var level = <%=(int)Session["userLevel"]%>;

    var foldLevel = 1, dateBegin = null, dateEnd = null;

    function refreshModifyInfo(cv)
    {
        cv.commitEdit();
        if (cv.itemsEdited.length > 0 || cv.itemsRemoved.length > 0) {
            $("#modifyInfos").html("<div class='alert alert-warning'><span class='glyphicon glyphicon-info-sign'></span> �޸ļ�¼���޸� " + cv.itemsEdited.length + " ����ɾ�� " + cv.itemsRemoved.length + " ����</div>");
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

        $("#recordsInfo").html(" �� <b>" + cv.sourceCollection.length + "</b> ����¼��ÿҳ��ʾ <b>" + cv.pageSize + "</b> ����");
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
                    //$("#msgboxTitle").html("<span class=\"glyphicon glyphicon-ok\"/> ҵ�����ݱ���ɹ�");
                    //$("#msgboxBody").html("�ܹ��ɹ����� " + data.successNum + " ��ҵ�����ݡ�[message: " + data.message + "]");
                    //$("#msgbox").modal();
                    var cv = new wijmo.collections.CollectionView(data.records);
                    cv.trackChanges = true;
                    dataViewer.itemsSource = cv;
                    cv.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription("employee"));
                    dataViewer.collapseGroupsToLevel(foldLevel);

                    dataViewer.columns.getColumn('employee').dataMap = new wijmo.grid.DataMap(data.employees, "id", "name");

                    cv.currentChanged.addHandler(function (sender, args) {
                        if (cv.currentItem != null)
                            $("#bottomTip").html(cv.currentItem.para.text);
                        refreshModifyInfo(cv)
                    });

                    cv.pageSize = 10;
                    updateNaviagteButtons();
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
                    alert("�Ǳ����ڲ���Ϊ�գ�ID=" + cv.itemsEdited[i].id);
                    return;
                }

                if (cv.itemsEdited[i].receivable == "")
                    cv.itemsEdited[i].receivable = 88888888;
                if (cv.itemsEdited[i].arrival == "")
                    cv.itemsEdited[i].arrival = 88888888;
                if (cv.itemsEdited[i].arrivalOld == "")
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
                        //$("#msgboxTitle").html("<span class=\"glyphicon glyphicon-ok\"/> ҵ�����ݱ���ɹ�");
                        //$("#msgboxBody").html("�ܹ��ɹ����� " + data.successNum + " ��ҵ�����ݡ�[message: " + data.message + "]");
                        //$("#msgbox").modal();
                        //var cv = new wijmo.collections.CollectionView(data.records);
                        //cv.trackChanges = true;
                        //dataViewer.itemsSource = cv;
                        //cv.groupDescriptions.push(new wijmo.collections.PropertyGroupDescription("employeeName"));
                        //dataViewer.collapseGroupsToLevel(foldLevel);

                        //cv.currentChanged.addHandler(function (sender, args) {
                        //    $("#bottomTip").html(cv.currentItem.para.text);
                        //    if (cv.itemsEdited.length > 0 || cv.itemsRemoved.length > 0) {
                        //        $("#modifyInfos").html("<div class='alert alert-warning'><span class='glyphicon glyphicon-info-sign'></span> �޸ļ�¼���޸� " + cv.itemsEdited.length + " ����ɾ�� " + cv.itemsRemoved.length + " ����</div>");
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
        //    $("#paragraphInfo").html("�� " + $("#paragraphText").val().length + " �ַ���");
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
                { header: '�Ǳ�����', binding: 'publishTime', width:100, dataType: "Date", isReadOnly: level != 0 && level != 2},
                { header: '��������', binding: 'magazine', width:120, isReadOnly: level != 0 && level != 2},
                { header: '����', binding: 'accused', isReadOnly: level != 0 && level != 2 },
                { header: 'ԭ��', binding: 'accuser', isReadOnly: level != 0 && level != 2 },
                { header: '��Ժ', binding: 'court', width:250, isReadOnly: level != 0 && level != 2 },
                { header: '��ͥ', binding: 'courtRoom',  isReadOnly: level > 2 },
                { header: '����', binding: 'judge', visible: level <= 1 || level == 2 },
                { header: '�绰', binding: 'telephone', visible: level <= 1 || level == 2 },
                { header: '��Ʊ��', binding: 'invoiceNumber', visible: level <= 1 || level == 2 },
                { header: '����', binding: 'magazinePage'},
                { header: '����', binding: 'type', width: 100, isReadOnly: level != 0 && level != 2 },
                { header: 'ҵ��Ա', binding: 'employee', width: 100, isReadOnly: level != 0 && level != 2, visible: level == 0 || level == 2},
                //{ header: '��������', binding: 'title', isReadOnly: lockField },
                //{ header: '¼������', binding: 'date', dataType: "Date", isReadOnly: true },
                { header: 'Ӧ�ս��', binding: 'receivable', dataType: "Number", format: 'c', visible: level <= 2 },
                { header: 'ʵ�ս��', binding: 'arrival', dataType: "Number", format: 'c', visible: level <= 1 },
                { header: '��������', binding: 'arrivalTime', dataType: "Date", isReadOnly: true, visible: level <= 1 },
                { header: '����;��', binding: 'arrivalFrom', visible: level <= 1 },
                //{ header: '״̬', binding: 'status', width: '*', isReadOnly: true },
                { header: '��Ժ��ַ', binding: 'courtAddress'},
                { header: '��ע', binding: 'remark'}
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
            }
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
                if (fullRs[i].employee != eval(val))
                    continue;
                totalReceivable += (fullRs[i].receivable == "" ? 0 : eval(fullRs[i].receivable));
                if (fullRs[i].arrival != "")
                    totalArrival += eval(fullRs[i].arrival);
                else totalUnarrival += 1;
                n += 1;
            }
            if (level >= 2)
                return "<span>" + fldDisp + "��" + valDisp + " (" + n + " ��Ŀ)";

            return "<span>" + valDisp + " (" + n + " ����¼, Ӧ���ʿ�ƣ� " + wijmo.Globalize.formatNumber(totalReceivable, 'c') 
                + "��ʵ�գ� " + wijmo.Globalize.formatNumber(totalArrival, 'c') 
                + "��δ���ʣ� " + totalUnarrival + " ��)"
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
            updateNaviagteButtons();
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
        
        //$("#saveBizdata").attr("disabled", level >= 2);
        //updateNaviagteButtons();
        if (level >= 2)
            $("#saveBizdata").hide();
    });
</script>
