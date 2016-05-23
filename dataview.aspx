
<%@ Page Language="C#" %>
<%@ import namespace="System" %>
<%@ import namespace="System.Web.UI" %>
<%
    if (Application["userId"] == null)
    {
        Response.Redirect("index.aspx", true);
    }
%>

<div class="container">
    <h2><span class="glyphicon glyphicon-edit"></span> ������޸���¼���ҵ������</h2>
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
                    <li data-toggle="pill" class="active" id="viewYear"><a href="#">����</a></li>
                    <li data-toggle="pill" id="viewMonth"><a href="#">����</a></li>
                    <li data-toggle="pill" id="viewDay"><a href="#">����</a></li>
                </ul>
            </td>
            <td>
                <input id="pagingInput" type="text" class="form-control col-md-1" placeholder="0 or empty is for no paging." value="10" />
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
        <span class="glyphicon glyphicon-floppy-saved"></span> �����޸�
    </button>
</div>

<script>

    var foldLevel = 1, dateBegin = null, dateEnd = null;

    function refreshModifyInfo(cv)
    {
        if (cv.itemsEdited.length > 0 || cv.itemsRemoved.length > 0) {
            $("#modifyInfos").html("<div class='alert alert-warning'><span class='glyphicon glyphicon-info-sign'></span> �޸ļ�¼���޸� " + cv.itemsEdited.length + " ����ɾ�� " + cv.itemsRemoved.length + " ����</div>");
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

                    cv.currentChanged.addHandler(function (sender, args) {
                        if (cv.currentItem != null)
                            $("#bottomTip").html(cv.currentItem.para.text);
                        refreshModifyInfo(cv)
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
        var lockField = <%=((int)Application["userLevel"] == 0 ? "false" : "true")%>;

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
                { header: 'ID', binding: 'id', width: 80 },
                { header: '����', binding: 'type', width: 100 },
                { header: '�Ǳ�����', binding: 'publishTime', dataType: "Date", isReadOnly: lockField},
                { header: '��������', binding: 'magazine', isReadOnly: lockField},
                { header: 'ҵ��Ա', binding: 'employee', width: 100, isReadOnly: lockField, visible: !lockField},
                { header: '����', binding: 'accused', isReadOnly: lockField },
                { header: 'ԭ��', binding: 'accuser', isReadOnly: lockField },
                { header: '��Ժ', binding: 'court', isReadOnly: lockField },
                { header: '��ͥ', binding: 'courtRoom', isReadOnly: lockField },
                { header: '��������', binding: 'title', isReadOnly: lockField },
                { header: '����', binding: 'judge' },
                { header: '�绰', binding: 'telephone' },
                { header: '¼������', binding: 'date', dataType: "Date", isReadOnly: true },
                { header: 'Ӧ�ս��', binding: 'receivable', dataType: "Number", format: 'c' },
                { header: 'ʵ�ս��', binding: 'arrival', dataType: "Number", format: 'c' },
                { header: '��������', binding: 'arrivalTime', dataType: "Date", isReadOnly: true },
                { header: '����;��', binding: 'arrivalFrom' },
                //{ header: '״̬', binding: 'status', width: '*', isReadOnly: true },
                { header: '��ע', binding: 'remark'}
            ],
            cellEditEnded: function (e) {
                //alert(dataViewer.itemsSource.itemsEdited.length);
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
        dataViewer.columns.getColumn('employee').dataMap = new wijmo.grid.DataMap(employees, "id", "name");
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
            return "<span>" + fldDisp + ":" + valDisp + " (" + n + " ��Ŀ, Ӧ���ʿ�ƣ� " + wijmo.Globalize.formatNumber(totalReceivable, 'c') 
                + "��ʵ�գ� " + wijmo.Globalize.formatNumber(totalArrival, 'c') 
                + "��δ���ʣ� " + totalUnarrival + " ��)"
                + "</span>";
        }

        dataViewerFilter = new wijmo.grid.filter.FlexGridFilter(dataViewer);

        queryNow();

        $("#pagingInput").on('blur', function () {
            dataViewer.itemsSource.pageSize = wijmo.Globalize.parseInt(
                this.value == "" ? "0" : this.value);
            updateNaviagteButtons();
        });

        var     btnFirstPage = document.getElementById('btnMoveToFirstPage'),
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
        }

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
        
        //updateNaviagteButtons();
    });
</script>
