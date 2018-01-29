<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>员工列表</title>
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<script type="text/javascript" src="static/js/jQuery-1.12.4-min.js"></script>
<link href="static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
<script src="static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12">
				<h1>员工管理系统</h1>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<div class="col-md-4 col-md-offset-8">
				<button type="button" class="btn btn-success btn-primary">新增</button>
				<button type="button" class="btn btn-danger btn-primary">删除</button>
				<p></p>
			</div>
		</div>
		<!-- 显示表格数据 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover">
					<tr>
						<th>编号</th>
						<th>姓名</th>
						<th>性别</th>
						<th>email</th>
						<th>部门</th>
						<th>操作</th>
					</tr>
					<c:forEach items="${pageInfo.list }" var="emp">
						<tr>
							<th>${emp.empId }</th>
							<th>${emp.empName }</th>
							<th>${emp.gender=="M"?"男":"女" }</th>
							<th>${emp.email }</th>
							<th>${emp.department.deptName }</th>
							<th>
								<button class="btn btn-primary btn-sm">
									<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
									编辑
								</button>
								<button class="btn btn-danger btn-sm">
									<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
									删除
								</button>
							</th>
						</tr>
					</c:forEach>


				</table>
			</div>
		</div>
		<!-- 显示分页信息，下一页 -->
		<div class="row">
			<div class="col-md-6">当前第${pageInfo.pageNum }页,共${pageInfo.pages }页
				共${pageInfo.total }条记录</div>
			<div class="col-md-6">
				<nav aria-label="Page navigation">
				<ul class="pagination">
					<li><a href="${APP_PATH }/emps?pn=1	">首页</a></li>
					<c:if test="${pageInfo.pageNum==1 }">
						<li class="disabled"><a
							href="${APP_PATH }/emps?pn=${pageInfo.pageNum }"
							aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
						</a></li>
					</c:if>
					<c:if test="${pageInfo.pageNum!=1 }">
						<li><a
							href="${APP_PATH }/emps?pn=${pageInfo.pageNum-1 }"
							aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
						</a></li>
					</c:if>
					<c:forEach items="${pageInfo.navigatepageNums }" var="pageNum">
						<c:if test="${pageInfo.pageNum==pageNum }">
							<li class="active"><a href="#">${pageNum }</a></li>
						</c:if>
						<c:if test="${pageInfo.pageNum!=pageNum }">
							<li><a href="${APP_PATH }/emps?pn=${pageNum }">${pageNum }</a></li>
						</c:if>
					</c:forEach>
					<c:if test="${pageInfo.pageNum==pageInfo.pages }">
						<li class="disabled"><a
							href="${APP_PATH }/emps?pn=${pageInfo.pageNum }"
							aria-label="Next"> <span aria-hidden="true">&raquo;</span>
						</a></li>
					</c:if>
					<c:if test="${pageInfo.pageNum!=pageInfo.pages }">
						<li><a
							href="${APP_PATH }/emps?pn=${pageInfo.pageNum+1 }"
							aria-label="Next"> <span aria-hidden="true">&raquo;</span>
						</a></li>
					</c:if>
					<li><a href="${APP_PATH }/emps?pn=${pageInfo.pages }">尾页</a></li>
				</ul>
				</nav>
			</div>
		</div>

	</div>



</body>
</html>