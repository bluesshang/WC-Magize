
<%@ Page Language="C#" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <title>文萃报刊信息登记管理系统</title>
  <meta charset="utf-8">
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
  
  <link rel="stylesheet" href="css/app.css">

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
        <li class="dropdown">
        	<a href="#" class="dropdown-toggle" data-toggle="dropdown">
        		<span class="glyphicon glyphicon-user"></span> 刘志杰(admin) <span class="caret"></span>
        	</a>
          <ul class="dropdown-menu">
            <li><a href="#">修改密码</a></li>
            <li><a href="#">修改个人信息</a></li>
            <li><a href="#">...</a></li> 
          </ul>
        </li>
        <li><a href="index.html"><span class="glyphicon glyphicon-log-out"></span> 退出系统 </a></li>
      </ul>
    </div>
  </div>
</nav>

<table border=0 width="100%">
	<tr>
		<td style="width:25%;min-width:300px;max-width:500px;margin-left:5px;vertical-align:top;">
			<div style="padding-right: 15px;padding-left: 15px; margin-right: auto; margin-left: auto;">
			  <h2>Accordion Example</h2>
			  <p><strong>Note:</strong> The <strong>data-parent</strong> attribute makes sure that all collapsible elements under the specified parent will be closed when one of the collapsible item is shown.</p>
			  <div class="panel-group" id="accordion">
			    <div class="panel panel-primary">
			      <div class="panel-heading">
			        <h4 class="panel-title">
			          <a data-toggle="collapse" data-parent="#accordion" href="#collapse1">业务数据录入</a>
			        </h4>
			      </div>
			      <div id="collapse1" class="panel-collapse collapse in">
			        <div class="panel-body">录入新的报刊登记信息.</div>
						  <div class="list-group">
						    <a href="#" class="list-group-item "><span class="badge">unknown:400</span>
						      <h4 class="list-group-item-heading">批量录入</h4>
						      <p class="list-group-item-text">通过文件的方式，系统会尽可能解析文件中的业务数据，一次性录入多条记录。</p>
						    </a>
						    <a href="#" class="list-group-item"><span class="badge">125</span>
						      <h4 class="list-group-item-heading">单条录入</h4>
						      <p class="list-group-item-text">List Group Item Text</p>
						    </a>
						    <a href="#" class="list-group-item">
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
			        <div class="panel-body">Lorem ipsum dolor sit amet, consectetur adipisicing elit,
			        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
			        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</div>
			        <div class="panel-body">Lorem ipsum dolor sit amet, consectetur adipisicing elit,
			        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
			        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</div>
			        <div class="panel-body">Lorem ipsum dolor sit amet, consectetur adipisicing elit,
			        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
			        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</div>
			        <div class="panel-body">Lorem ipsum dolor sit amet, consectetur adipisicing elit,
			        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
			        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</div>
			        <div class="panel-body">Lorem ipsum dolor sit amet, consectetur adipisicing elit,
			        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
			        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</div>
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
			</div>			
		</td>
		<td>
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
			      <h2>Chandler Bing, Guitarist</h2>
			      <p>Always a pleasure people! Hope you enjoyed it as much as I did. Could I BE.. any more pleased?</p>
			      <form role="form">
							<div class="form-group">
							  <label for="comment">请输入一段或多段完整的报刊业务登记数据：</label>
							  <a href="#" onclick="new function(){$('#bizDataSample').modal();}">查看示例 ...</a>
							  <textarea class="form-control" rows="7" id="comment"></textarea>
							  <span class="help-block">例如：“XXX：本院受理XXX诉你XXX一案，并定于2015年3月30日上午10：30在XXX公开开庭审理。XXX人民法院”</span>
							</div>
							<button type="submit" class="btn btn-primary">提 交</button>
							<button class="btn btn-default">清 空</button>
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
			  <div id="my_rawGrid" class="panel panel-primary"></div>
			</div>			
		</td>
	</tr>
</table>

<div class="container">
  <div class="modal fade" id="myLoginModal" role="dialog">
    <div class="modal-dialog">
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="padding:35px 50px;">
        	<button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4><span class="glyphicon glyphicon-lock"></span> 请输入系统登录信息</h4>
        </div>
        <div class="modal-body" style="padding:40px 50px;">
          <form role="form">
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
        <p>苗伟：本院受理原告张育升诉你民间借贷纠纷一案，因你下落不明，现依法向你公告送达起诉书副本、应诉通知书、举证通知书及开庭传票。自公告之日起经过60日即视为送达。提交答辩状和举证期限均为公告期满后的15日内。并定于2015年3月30日下午2：30在本院横岗法庭第三审判庭公开开庭审理，无正当理由拒不到庭的，本院将作出缺席判决。
					<br>广东省深圳市龙岗区人民法院
				</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>

  </div>
</div>

<script>
$(document).ready(function(){
    $("#myLoginBtn").click(function(){
        $("#myLoginModal").modal();
    });
        
    $("#myLoginModal").modal();
    
    // $('[data-toggle="popover"]').popover();  
    {
	    var count = 100;
	    var data = [];
	
	    for (var i = 0; i < count ; i++) {
	        data.push({
	            序号: "00" + (i + 1).toString(),
	            ID号: "21601" + i.toString(),
	            英文名: "TingTao Ge",
	            中文名: "听涛阁",
	            最小楼层: 2,
	            最大楼层: 12,
	            状态: true,
	            日期: new Date(2014, i % 12, i % 28),
	        });
	    }
	    var cv = new wijmo.collections.CollectionView(data);
	
	    my_rawGrid = new wijmo.grid.FlexGrid('#my_rawGrid', {
	        showSelectedHeaders: 'All',
	        itemsSource: cv
	            //new wijmo.odata.ODataCollectionView(
	            //'http://services.odata.org/V4/Northwind/Northwind.svc/',
	            //'Order_Details_Extendeds'),
	    });
	
	    my_rawGridFilter = new wijmo.grid.filter.FlexGridFilter(my_rawGrid);    	
    }
    
    /*$("#wijeditor").wijeditor({
        editorMode: "split",
        mode: "simple",
        //simpleModeCommands: ["Bold", "Italic", "Link", "BlockQuote", "StrikeThrough", "InsertDate", "InsertImage", "NumberedList", "BulletedList", "InsertCode"]
        simpleModeCommands: ["Bold", "Italic", "FontName", "FontSize", "InsertImage", "NumberedList", "BulletedList", "Undo"]
    });    */
});
</script>
</body>
</html>	