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

<!-- 设置访问人数 -->
<%@ page import="com.cmw.utils.Counter"%>
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

<!-- 设置cookie  -->
<%
	Cookie[] cookies = request.getCookies();
	String name = null;
	if (cookies != null) {
		for (Cookie cookie : cookies) {
			if (cookie.getName().equals("login")) {
				name = cookie.getValue();
			}
		}
	}
	if (name == null) {
%>
<jsp:forward page="login.jsp" />
<%
	}
%>

<script type="text/javascript"
	src="${APP_PATH }/static/js/jquery-3.2.1.min.js"></script>
<script
	src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<link
	href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">


</head>
<body>
	<!-- 新增按钮模态框 -->
	<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">员工添加</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal">
						<div class="form-group">
							<label for="empName_add_input" class="col-sm-2 control-label">姓名：</label>
							<div class="col-sm-10">
								<input type="text" name="empName" class="form-control"
									id="empName_add_input" placeholder="Name"> <span
									class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="email_add_input" class="col-sm-2 control-label">Email：</label>
							<div class="col-sm-10">
								<input type="text" name="email" class="form-control"
									id="email_add_input" placeholder="example@cmw.com"> <span
									class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="gender_add_input" class="col-sm-2 control-label">性别：</label>
							<div class="col-sm-10">
								<label class="radio-inline"> <input type="radio"
									name="gender" id="gender1_add_input" value="M"
									checked="checked"> 男
								</label> <label class="radio-inline"> <input type="radio"
									name="gender" id="gender2_add_input" value="F"> 女
								</label>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">部门：</label>
							<div class="col-sm-4">
								<!--  -->
								<select class="form-control" name="dId" id="dept_add_select">
								</select>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" id="emp_save_btn" class="btn btn-primary">保存</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 修改按钮模态框  -->
	<div class="modal fade" id="empUpDateModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">员工修改</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal">
						<div class="form-group">
							<label for="empName_update_input" class="col-sm-2 control-label">姓名：</label>
							<div class="col-sm-10">
								<p class="form-control-static" id="empName_update_static">
									<span class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="email_update_input" class="col-sm-2 control-label">Email：</label>
							<div class="col-sm-10">
								<input type="text" name="email" class="form-control"
									id="email_update_input" placeholder="example@cmw.com">
								<span class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="gender_update_input" class="col-sm-2 control-label">性别：</label>
							<div class="col-sm-10">
								<label class="radio-inline"> <input type="radio"
									name="gender" id="gender1_update_input" value="M"
									checked="checked"> 男
								</label> <label class="radio-inline"> <input type="radio"
									name="gender" id="gender2_update_input" value="F"> 女
								</label>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">部门：</label>
							<div class="col-sm-4">
								<!--  -->
								<select class="form-control" name="dId" id="dept_update_select">
								</select>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" id="emp_update_btn" class="btn btn-primary">更新</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>


	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-8">
				<h1>员工管理系统</h1>
				<div class="col-md-4 col-md-offset-12">
					<h4>
						(当前用户：<%=name%>)
					</h4>
				</div>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<div class="col-md-4 col-md-offset-8">
				<button type="button" class="btn btn-success btn-primary"
					id="emp_add_model_btn">新增</button>
				<button type="button" class="btn btn-danger btn-primary"
					id="emp_del_all_btn">删除</button>
				<p></p>
			</div>
		</div>
		<!-- 显示表格数据 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover" id="emps_table">
					<thead>
						<tr>
							<th><input type="checkbox" id="check_all"></th>
							<th>编号</th>
							<th>姓名</th>
							<th>性别</th>
							<th>email</th>
							<th>部门</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>

					</tbody>
				</table>
			</div>
		</div>
		<!-- 显示分页信息，下一页 -->
		<div class="row">
			<div class="col-md-6" id="page_info_area"></div>
			<div class="col-md-6" id="page_nav_area"></div>
		</div>
		<!-- 显示计数信息  -->
		<div class="row">
			<div class="col-md-6 col-md-offset-4">
				您是访问本网站的第&nbsp;<kbd><%=count%></kbd>&nbsp;位管理人员
			</div>
		</div>
	</div>







	<script type="text/javascript">
		var totalPage, currentPage;
		//1.页面加载完直接发送ajax请求,获取分页数据
		$(function() {
			to_page(1);
		});

		//页面跳转
		function to_page(pn) {
			$.ajax({
				type : "GET",
				url : "${APP_PATH }/emps",
				data : "pn=" + pn,
				success : function(result) {
					//console.log(result);
					//2.解析并显示员工数据
					build_emps_table(result);
					//3.解析并显示分页信息
					build_page_info(result);
					//4.解析并显示分页条
					build_page_nav(result);
				}
			});
		}

		//模态框
		function build_emps_table(result) {
			$("#emps_table tbody").empty();
			var emps = result.extend.pageInfo.list;
			$
					.each(
							emps,
							function(index, item) {
								var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
								var empIdTd = $("<td></td>").append(item.empId);
								var empNameTd = $("<td></td>").append(
										item.empName);
								var gender = item.gender == 'M' ? "男" : "女"
								var genderTd = $("<td></td>").append(gender);
								var emailTd = $("<td></td>").append(item.email);
								var deptNameTd = $("<td></td>").append(
										item.department.deptName);
								var editBtn = $("<button></button>")
										.addClass(
												"btn  btn-primary btn-sm edit_btn")
										.append(
												$("<span></span>")
														.addClass(
																"glyphicon glyphicon-pencil"))
										.append("修改");
								//为编辑按钮添加一个自定义的属性，表示当前员工id
								editBtn.attr("edit_id", item.empId);
								var delBtn = $("<button></button>")
										.addClass(
												"btn  btn-danger btn-sm delete_btn")
										.append(
												$("<span></span>")
														.addClass(
																"glyphicon glyphicon-trash"))
										.append("删除");
								//为删除按钮添加一个自定义的属性，表示当前员工id
								delBtn.attr("del_id", item.empId);
								$("<tr></tr>").append(checkBoxTd).append(
										empIdTd).append(empNameTd).append(
										genderTd).append(emailTd).append(
										deptNameTd).append(editBtn).append(
										delBtn).appendTo("#emps_table tbody");
							});
		};

		//解析分页信息
		function build_page_info(result) {
			$("#page_info_area").empty();
			$("#page_info_area").append(
					"当前第<kbd>" + result.extend.pageInfo.pageNum
							+ "</kbd>页,共<kbd>" + result.extend.pageInfo.pages
							+ "</kbd>页,共<kbd>" + result.extend.pageInfo.total
							+ "</kbd>条记录")
			totalPage = result.extend.pageInfo.total;
			currentPage = result.extend.pageInfo.pageNum;
		}

		//解析分页条
		function build_page_nav(result) {
			$("#page_nav_area").empty();
			var ul = $("<ul></ul>").addClass("pagination");
			var firstPageLi = $("<li></li>").append(
					$("<a></a>").append("首页").attr("href", "#"));
			var prePageLi = $("<li></li>").append(
					$("<a></a>").append("&laquo;").attr("href", "#"));
			if (result.extend.pageInfo.hasPreviousPage == false) {
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			} else {
				//添加单击事件
				firstPageLi.click(function() {
					to_page(1);
				});
				prePageLi.click(function() {
					to_page(result.extend.pageInfo.pageNum - 1);
				});
			}

			var nextPageLi = $("<li></li>").append(
					$("<a></a>").append("&raquo;").attr("href", "#"));
			var lastPageLi = $("<li></li>").append(
					$("<a></a>").append("尾页").attr("href", "#"));
			if (result.extend.pageInfo.hasNextPage == false) {
				nextPageLi.addClass("disabled");
				lastPageLi.addClass("disabled");
			} else {
				nextPageLi.click(function() {
					to_page(result.extend.pageInfo.pageNum + 1);
				});
				lastPageLi.click(function() {
					to_page(result.extend.pageInfo.pages);
				});
			}

			//添加首页和前一页
			ul.append(firstPageLi).append(prePageLi);
			//遍历页码号
			$.each(result.extend.pageInfo.navigatepageNums, function(index,
					item) {
				var numLi = $("<li></li>").append($("<a></a>").append(item));

				if (result.extend.pageInfo.pageNum == item) {
					numLi.addClass("active");
				}
				numLi.click(function() {
					to_page(item);
				})
				ul.append(numLi);
			});
			//添加下一页和末页
			ul.append(nextPageLi).append(lastPageLi);
			var nav = $("<nav></nav>").append(ul);
			nav.appendTo("#page_nav_area");
		}

		function reset_form(ele) {
			$(ele)[0].reset();
			//清空表单样式
			$(ele).find("*").removeClass("has-success has-error");
			$(ele).find(".help-block").text("");
		}

		//点击新增按钮弹出模态框
		$("#emp_add_model_btn").click(function() {
			//清楚表单数据(表单重置)
			reset_form("#empAddModal form");
			//发送ajax请求，查询部门信息，并显示在下拉列表中
			getDepts("#dept_add_select");
			//弹出模态框
			$("#empAddModal").modal({
				backdrop : "static"
			});
		});

		function getDepts(ele) {
			$(ele).empty();
			$.ajax({
				url : "${APP_PATH}/depts",
				typr : "GET",
				success : function(result) {
					//显示信息在下拉列表中
					$.each(result.extend.depts, function() {
						var optionEle = $("<option></option>").append(
								this.deptName).attr("value", this.deptId);
						optionEle.appendTo(ele);
					});
				}
			});
		}

		//检验表单
		function validate_add_form() {
			//1.获取要校验的信息，用正则表达式验证
			var empName = $("#empName_add_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u4e00-\u9fa5]{2,5})/;
			if (!regName.test(empName)) {
				//alert("用户名错误：请输入2-5位的中文或6-16位的英文和数字组合!");
				show_validate_msg("#empName_add_input", "error",
						"用户名错误：请输入2-5位的中文或6-16位的英文和数字组合!");
				return false;
			} else {
				show_validate_msg("#empName_add_input", "success", "");
			}
			;
			//2.校验邮箱
			var email = $("#email_add_input").val();
			var regEmail = /(^^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$)/;
			if (!regEmail.test(email)) {
				//alert("邮箱错误：邮箱输入有误,请检查!");
				show_validate_msg("#email_add_input", "error",
						"邮箱错误：邮箱输入有误,请检查!");
				return false;
			} else {
				show_validate_msg("#email_add_input", "success", "");
			}
			return true;
		}

		//校验结果的错误信息
		function show_validate_msg(ele, status, msg) {
			//清楚当前元素状态
			$(ele).parent().removeClass("has-success has-error");
			$(ele).next("span").text(msg);
			if (status == "success") {
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			} else if (status == "error") {
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
			}
		}

		$("#empName_add_input").change(
				function() {
					//发送ajax请求
					var empName = this.value;
					$.ajax({
						url : "${APP_PATH}/checkuser",
						data : "empName=" + empName,
						type : "POST",
						success : function(result) {
							if (result.code == 100) {
								show_validate_msg("#empName_add_input",
										"success", "用户名可用");
								$("#emp_save_btn").attr("ajax-va", "success");
							} else {
								show_validate_msg("#empName_add_input",
										"error", result.extend.va_msg);
								$("#emp_save_btn").attr("ajax-va", "error");
							}
						}
					});
				});

		//点击保存，保存员工
		$("#emp_save_btn")
				.click(
						function() {
							//1.模态框中点击保存后将数据提交给服务器
							// 			if (!validate_add_form()) {
							// 				return false;
							// 			}
							//判断ajax用户名检验是否成功
							if ($(this).attr("ajax-va") == "error") {
								return false;
							}

							//2.发送ajax请求保存员工
							$
									.ajax({
										url : "${APP_PATH}/emp",
										type : "POST",
										data : $("#empAddModal form")
												.serialize(),
										success : function(result) {
											//alert(result.msg);

											if (result.code == 100) {
												//1.关闭模态框
												$("#empAddModal").modal("hide");
												//2.跳转最后一页，显示新增信息
												//发送ajax请求显示最后一页数据即可
												//自定义一个大的数，这里用记录数表示
												to_page(totalPage);
											} else {
												//检验失败，显示失败信息
												if (undefined != result.extend.errorFields.email) {
													//邮箱的错误信息
													show_validate_msg(
															"#email_add_input",
															"error",
															result.extend.errorFields.email);
												}
												if (undefined != result.extend.errorFields.empName) {
													show_validate_msg(
															"#empName_add_input",
															"error",
															result.extend.errorFields.empName);
												}
											}

										}
									});
							//alert($("#empAddModal form").serialize());
						});

		$(document).on("click", ".edit_btn", function() {
			//1.查出部门信息，显示在模态框中
			getDepts("#dept_update_select");
			//2.查出员工信息，显示在模态框中
			getEmp($(this).attr("edit_id"));
			//3.把员工id传递给模态框的更新按钮
			$("#emp_update_btn").attr("edit_id", $(this).attr("edit_id"));

			$("#empUpDateModal").modal({
				backdrop : "static"
			});
		});

		function getEmp(id) {
			$.ajax({
				url : "${APP_PATH}/emp/" + id,
				type : "GET",
				success : function(result) {
					var empData = result.extend.emp;
					$("#empName_update_static").text(empData.empName);
					$("#email_update_input").val(empData.email);
					$("#empUpDateModal input[name=gender]").val(
							[ empData.gender ]);
					$("#empUpDateModal select").val([ empData.dId ]);
				}
			});
		}

		$("#emp_update_btn")
				.click(
						function() {
							//检验邮箱是否合法
							//1.校验邮箱
							var email = $("#email_update_input").val();
							var regEmail = /(^^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$)/;
							if (!regEmail.test(email)) {
								//alert("邮箱错误：邮箱输入有误,请检查!");
								show_validate_msg("#email_update_input",
										"error", "邮箱错误：邮箱输入有误,请检查!");
								return false;
							} else {
								show_validate_msg("#email_update_input",
										"success", "");
							}

							//2.发送ajax请求保存更新的员工数据
							$.ajax({
								url : "${APP_PATH}/emp/"
										+ $(this).attr("edit_id"),
								type : "PUT",
								data : $("#empUpDateModal form").serialize(),
								//type:"POST",
								//data:$("#empUpDateModal form").serialize()+"&_method=PUT",
								success : function(result) {
									//alert(result.msg);
									//1.关闭对话框
									$("#empUpDateModal").modal("hide");
									//2.回到本页面
									to_page(currentPage);
								}

							});

						});
		//单个删除
		$(document).on("click", ".delete_btn", function() {
			//1.弹出确认删除对话框
			var empName = $(this).parents("tr").find("td:eq(2)").text();
			var empId = $(this).attr("del_id");
			if (confirm("确认删除【" + empName + "】吗？")) {
				//确认发送ajax请求
				$.ajax({
					url : "${APP_PATH}/emp/" + empId,
					type : "DELETE",
					success : function(result) {
						//1.关闭对话框
						$("#empUpDateModal").modal("hide");
						//2.回到本页面
						to_page(currentPage);
					}
				});
			}
		});

		//全选框
		$("#check_all").click(function() {
			//attr获取check是undefined
			//$(this).prop("checked");
			$(".check_item").prop("checked", $(this).prop("checked"));
		});

		$(document)
				.on(
						"click",
						".check_item",
						function() {
							//判断当前选择的元素是不是5个
							var flag = $(".check_item:checked").length == $(".check_item").length;
							$("#check_all").prop("checked", flag);
						});

		//批量删除
		$("#emp_del_all_btn").click(
				function() {
					var empNames = "";
					var del_idstr = "";
					$.each($(".check_item:checked"), function() {
						empNames += $(this).parents("tr").find("td:eq(2)")
								.text()
								+ ",";
						del_idstr += $(this).parents("tr").find("td:eq(1)")
								.text()
								+ "-";
					});
					//去除最后的，
					empNames = empNames.substring(0, empNames.length - 1);
					//去除最后的-
					del_idstr = del_idstr.substring(0, del_idstr.length - 1);
					if (confirm("确认删除【" + empNames + "】吗？")) {
						$.ajax({
							url : "${APP_PATH}/emp/" + del_idstr,
							type : "DELETE",
							success : function(result) {
								alert(result.msg);
								//回到本页面
								to_page(currentPage);
							}
						});
					}

				});
	</script>


</body>
</html>