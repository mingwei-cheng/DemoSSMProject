<%@ page language="java" import="java.util.*" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>欢迎登陆</title>
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<%@ page import="com.cmw.utils.Counter"%>
<%@ page import="com.cmw.utils.GetIp"%>
<!-- 记录ip -->
<%
	GetIp getIp = new GetIp();
	String ip =null;
	ip = getIp.getIpAddr(request);
	if (session.isNew())
		ip = "\n"+ip;
	application.setAttribute("ip", ip);
	getIp.writeFile(request.getRealPath("/") + "ip.txt", ip);
%>


<!-- 记录人数 -->

<%
	Counter CountFileHandler = new Counter();//创建对象
	int count = 0;
	if (application.getAttribute("count") == null) {
		count = CountFileHandler.readFile(request.getRealPath("/") + "count.txt"); //读取文件获取数据赋给count
		application.setAttribute("count", new Integer(count));
	}
	count = (Integer) application.getAttribute("count");
	if (session.isNew())
		++count;
	application.setAttribute("count", count);
	CountFileHandler.writeFile(request.getRealPath("/") + "count.txt", count);//更新文件记录
%>
<!--  -->
<script type="text/javascript"
	src="${APP_PATH }/static/js/jquery-3.2.1.min.js"></script>
<script
	src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<link
	href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
</head>
<body>
	<div class="container-fluid jumbotron">
		<br> <br> <br> <br> <br> <br> <br>
		<h1 align="center">员工管理系统</h1>
		<div
			class="col-xs-4 col-sm-6 col-md-8 col-xs-offset-4 col-sm-offset-3 col-md-offset-2">
			<span><br></span>
			<div class="row col-lg-offset-3">
				<div class="input-group col-lg-8">
					<span class="input-group-addon" id="basic-addon1"><div
							class="glyphicon glyphicon-user"></div></span> <input type="text"
						class="form-control" placeholder="UserName" id="UserName"
						aria-describedby="basic-addon1">
				</div>
				<p></p>
			</div>
			<div class="row col-lg-offset-3">
				<p></p>
				<div class="input-group col-lg-8">
					<span class="input-group-addon" id="basic-addon1"><div
							class="glyphicon glyphicon-pencil"></div> </span> <input type="password"
						class="form-control" placeholder="PassWord" id="PassWord"
						aria-describedby="basic-addon1">
				</div>
				<p></p>
			</div>
			<!-- 			<div class="checkbox" id="login_check" align="center"> -->
			<!-- 				<p></p> -->
			<!-- 				<label><input type="checkbox" -->
			<!-- 					style="font-size: 80px; font-weight: normal;">保持登陆</label> -->
			<!-- 			</div> -->
			<p></p>
			<p></p>
			<div align="center">
				<p>
					<a class="btn btn-primary btn-lg" id="login_btn" href="#"
						role="button">登陆</a>
				</p>
			</div>
		</div>
		<div>
			<br> <br> <br> <br> <br> <br> <br>
			<br> <br> <br> <br> <br> <br> <br>
			<center>
				<p>你是第&nbsp;<kbd><%=count %></kbd>&nbsp;位访客</p>
			</center>
		</div>
	</div>

	<script type="text/javascript">
		$("#login_btn").click(function() {
			var userName = $("#UserName").val();
			var passWord = $("#PassWord").val();

			$.ajax({
				url : "${APP_PATH}/admin/" + userName + "-" + passWord,
				type : "PUT",
				success : function(result) {
					if (result.code == 100) {
						window.location.href = '${APP_PATH}/index.jsp';
					} else {
						alert("用户名密码错误，请重试！");
					}
				}
			})
		});
	</script>
</body>
</html>