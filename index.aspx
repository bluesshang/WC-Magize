
<%@ Page Language="C#" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>文萃报刊信息登记管理系统</title>
    <meta charset="utf-8">

    <link rel="stylesheet" href="css/bootstrap-3.3.6.css">
    <script src="js\jquery-2.0.0.js"></script>
    <script src="js\bootstrap-3.3.6.js"></script>

    <link rel="stylesheet" href="css/app.css">
    <link rel="shortcut icon" href="images/icon.jpg" type="image/x-icon" />

    <style>
  </style>

</head>

<body style="margin-top: 100px;">
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
                    <li><a href="#"><span class="glyphicon glyphicon-search"></span></a></li>
                    <li><a href="#"><span class="glyphicon glyphicon-user"></span>Sign Up</a></li>
                    <li><a href="#"><span class="glyphicon glyphicon-log-in"></span>Login</a></li>
                </ul>
            </div>
        </div>
    </nav>


    <div class="container" id="mainBox">
        <h2>欢迎使用文萃报刊信息登记系统</h2>
        <!-- Trigger the modal with a button -->
        <!--p><span class="glyphicon glyphicon-log-in"></span>请登录 ...</!--p-->
        <!-- Modal -->
        <div class="" id="myLoginModal" role="dialog">
            <div class="">
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header" style="padding: 35px 50px;">
                        <h4><span class="glyphicon glyphicon-lock"></span>请输入系统登录信息</h4>
                    </div>
                    <div class="modal-body" style="padding: 40px 50px;">
                        <form role="form" id="frmLogin">
                            <div class="form-group">
                                <label for="usrname"><span class="glyphicon glyphicon-user"></span> Username</label>
                                <input type="text" class="form-control" name="userName" id="userName" placeholder="请输入你的系统帐号">
                            </div>
                            <div class="form-group">
                                <label for="psw"><span class="glyphicon glyphicon-eye-open"></span> Password</label>
                                <input type="password" class="form-control" name="userPwd" id="userPwd" placeholder="Enter password">
                            </div>
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox" value="" checked>Remember me</label>
                            </div>
                            <button type="button" class="btn btn-success col-xs-3" id="login"><span class="glyphicon glyphicon-off"></span> Login</button>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <div id="loginInfo" class="pull-left"></div>
                        <p>Not a member? <a href="#">Sign Up</a></p>
                        <p>Forgot <a href="#">Password?</a></p>
                    </div>
                </div>
            </div>
        </div>
        <p style="margin-top: 30px; text-align: center">(c)2016 WenCui Magazine. <span class="glyphicon glyphicon-envelope"></span>blues.shang@yahoo.com </p>
    </div>

<script>
$(document).ready(function(){
    $("#login").click(function () {
        $("#loginInfo").html("正在登录 ...");
        $.ajax({
            type: 'post',
            url: 'do.aspx',
            //data: "op=1&data=" + JSON.stringify(dataViewer.itemsSource.items), //$("#form1").serialize(),
            data: "op=login&" + $("#frmLogin").serialize(),
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
                    location.href = data.url;
                } else {
                    $("#loginInfo").html("<span class='glyphicon glyphicon-remove-sign'> 登录失败，请检查你所输入的用户名和密码是否正确。</span>");
                }
            },
            error: function (o, message) {
                alert(message);
            }
        });
    });

    //alert(navigator.userAgent);
    //$("#myLoginModal").modal();
    if (navigator.userAgent.indexOf("Chrome") < 0) {
        $("#mainBox").html("<h3>请使用Google Chrome浏览器访问本系统！</h3> <br><br> 点击 <a href='tools/ChromeStandalone_50.0.2661.102_Setup.exe'>这里</a> 下载并安装，如果你已经安装，请在Chrome浏览器中访问本系统。");
    }
    // $('[data-toggle="popover"]').popover();  
});
</script>
</body>
</html>	