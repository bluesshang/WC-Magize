
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
      <a class="navbar-brand" href="#"><img src="images/log-small.jpg"></a>
    </div>
    <div class="collapse navbar-collapse" id="myNavbar">
      <ul class="nav navbar-nav navbar-right">
        <li><a href="#myPage">HOME</a></li>
        <li><a href="#band">BAND</a></li>
        <li><a href="#tour">TOUR</a></li>
        <li><a href="#contact">CONTACT</a></li>
        <li class="dropdown">
          <a class="dropdown-toggle" data-toggle="dropdown" href="#">MORE
          <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="#">Merchandise</a></li>
            <li><a href="#">Extras</a></li>
            <li><a href="#">Media</a></li> 
          </ul>
        </li>
        <li><a href="#"><span class="glyphicon glyphicon-search"></span></a></li>
        <li><a href="#"><span class="glyphicon glyphicon-user"></span> Sign Up</a></li>
        <li><a href="#"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
      </ul>
    </div>
  </div>
</nav>


<div class="container">
  <h2>欢迎使用文萃报刊信息登记系统</h2>
  <!-- Trigger the modal with a button -->
  <p><span class="glyphicon glyphicon-log-in"></span> 请登录 ...</p>
  <!-- Modal -->
  <div class="" id="myLoginModal" role="dialog">
    <div class="">
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="padding:35px 50px;">
          <h4><span class="glyphicon glyphicon-lock"></span> 请输入系统登录信息</h4>
        </div>
        <div class="modal-body" style="padding:40px 50px;">
          <form role="form" action="bizdata.aspx">
            <div class="form-group">
              <label for="usrname"><span class="glyphicon glyphicon-user"></span> Username</label>
              <input type="text" class="form-control" id="usrname" placeholder="请输入你的系统帐号">
            </div>
            <div class="form-group">
              <label for="psw"><span class="glyphicon glyphicon-eye-open"></span> Password</label>
              <input type="password" class="form-control" id="psw" placeholder="Enter password">
            </div>
            <div class="checkbox">
              <label><input type="checkbox" value="" checked>Remember me</label>
            </div>
              <button type="submit" class="btn btn-success btn-block"><span class="glyphicon glyphicon-off"></span> Login</button>
          </form>
        </div>
        <div class="modal-footer">
          <p>Not a member? <a href="#">Sign Up</a></p>
          <p>Forgot <a href="#">Password?</a></p>
        </div>
      </div>
    </div>
  </div> 
  <p align="center" style="margin-top:30px">(c)2016 WenCui Magazine.</p>
</div>

<script>
$(document).ready(function(){
    $("#myLoginBtn").click(function(){
        $("#myLoginModal").modal();
    });
        
    //$("#myLoginModal").modal();
    
    // $('[data-toggle="popover"]').popover();  
});
</script>
</body>
</html>	