<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="VNU.VnuData"%>
<%@ page import="DB.PersonalData"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="javax.swing.text.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<!-- jQuery library -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<!-- Latest compiled JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<link rel="icon" type="image/png" href="images/icons/favicon.ico" />
<link rel="stylesheet" type="text/css" href="css/util.css">
<link rel="stylesheet" type="text/css" href="css/main.css">
<link rel="stylesheet" type="text/css" href="css/subject.css">
</head>
<body>
	<%
		@SuppressWarnings("all")
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		int offset = Integer.parseInt(request.getParameter("offset"));
		
		String[] color_school = {"success","info","warning"};
		int number_school = 1;
		
		String[] color_personal = {"danger"};
		int number_personal = 1;
		
		VnuData vnu = new VnuData(username,password);
		if(vnu.responseCode != 200){
			response.sendRedirect("Login.jsp");
		}
		
		PersonalData pesonal = new PersonalData(offset);
		int user_id = pesonal.get_user_by_ma_sv(username);
		if (user_id == -1){
			pesonal.add_user(username, vnu.name);
		}
	%>
	<div class="limiter">
		<div class="container-login100">
			<div class="wrap-login100" style="width: 1200px!important">
				<table style = "border:none;width:100%">
					<tr>
						<td class="col-md-6"><p>Xin chào <b style="font-size: 20px;color : black"><%
							out.print(vnu.name);
						%></b> - Mã Sinh Viên: <b style="color : black"><%
							out.print(username);
						%></b></p><td>
						<td class="col-md-7"><p>Chương trình đào tạo: <b style="color : black"><%
							out.print(vnu.program);
						%></b></p><td>
					</tr>
					<tr>
						<td class="col-md-6"><p>Ngày sinh: <b style="color : black"><%
							out.print(vnu.birth);
						%></b></p><td>
						<td class="col-md-7"><p>Khóa: <b style="color : black"><%
							out.print(vnu.session);
						%></b></p><td>
					</tr>
				</table>
				<br>
				<ul class="nav nav-tabs">
				  <li class="active"><a data-toggle="tab" href="#vnu_calendar" id="vnu_calendar_active">Thời khóa biểu hiện tại</a></li>
				</ul>
				<br>
				<div class="tab-content">
				<%
					try {
						pesonal.get_data_by_week(user_id, offset);
						List result = pesonal.list_rs;
						vnu.merge_with_db(result);
						String[][] calendar = vnu.calendar;
						//vnu.printCalendar();
				%>
				  <div id="vnu_calendar" class="tab-pane fade in active">
				  	<table style="border-collapse: separate;  border-spacing: 10px 0px;">
				  		<tr>
				  			<td>
				  				<form action="Calendar.jsp?offset=<%= offset-1 %>" method="POST">
									<input type="text" name="id" value="<%= user_id %>" hidden> 
									<input type="text" name="username" value="<%= username %>" hidden> 
									<input type="password" name="password" value="<%= password %>" hidden>
									<button type="submit" class="btn btn-info">
									   <span class="glyphicon glyphicon-chevron-left"></span> Tuần trước
									</button>
								</form>
				  			</td>
				  			<td>
				  				<form action="PersonalCreateForm.jsp" method="POST">
									<input type="text" name="id" value="<%= user_id %>" hidden> 
									<input type="text" name="username" value="<%= username %>" hidden> 
									<input type="password" name="password" value="<%= password %>" hidden>
									<button type="submit" class="btn btn-success">
									 	Tạo hoạt động mới <span class="glyphicon glyphicon-plus"></span>
									</button>
								</form>
				  			</td>
				  			<td>
								<a href="VnuChat.jsp" class="btn btn-danger" target="_blank">
								 	VNU chat <span class="glyphicon glyphicon glyphicon-user"></span>
								</a>
				  			</td>
				  			<td>
				  				<form action="Calendar.jsp?offset=<%= offset+1 %>" method="POST" style="float: left">
									<input type="text" name="id" value="<%= user_id %>" hidden> 
									<input type="text" name="username" value="<%= username %>" hidden> 
									<input type="password" name="password" value="<%= password %>" hidden>
									<button type="submit" class="btn btn-info">
									   Tuần tiếp theo <span class="glyphicon glyphicon-chevron-right"></span>
									</button>
								</form> 
				  			</td>
				  		</tr>
				  	</table>
					<br>
				  	<table class="table table-bordered table-strpped">
						<tr style="text-align: center;table-layout: fixed;">
							<th class="col-md-1"><center>Tiết</center></th>
							<th class="col-md-1"><center>Thứ 2 <br><%= pesonal.getDayByIndex(0) %></center></th>
							<th class="col-md-1"><center>Thứ 3 <br><%= pesonal.getDayByIndex(1) %></center></th>
							<th class="col-md-1"><center>Thứ 4 <br><%= pesonal.getDayByIndex(2) %></center></th>
							<th class="col-md-1"><center>Thứ 5 <br><%= pesonal.getDayByIndex(3) %></center></th>
							<th class="col-md-1"><center>Thứ 6 <br><%= pesonal.getDayByIndex(4) %></center></th>
							<th class="col-md-1"><center>Thứ 7 <br><%= pesonal.getDayByIndex(5) %></center></th>
							<th class="col-md-1"><center>Chủ Nhật <br><%= pesonal.getDayByIndex(6) %></center></th>
						</tr>
						<%
						for (int i = 0; i < calendar.length; i++) {
						%>
						<tr>
							<%
								for (int j = 0; j < calendar[i].length; j++) {
									String value = calendar[i][j];
									if (j == 0) {
										%> <th><center> <%
											out.print(value);
										%> </center></th> <%
									} else {
										if (value == "KKKKKKK") {
											
										} else if (value == "0") {
											%><td></td><%
										} else {
											String[] subject_info = value.split("/");
											String span = subject_info[0];
											String id = subject_info[1];
											String src = subject_info[2];
											if (src.compareTo("DBN") == 0){
												String[] subject = pesonal.get_data_in_list(id);
												%><td rowspan="<% out.print(span);  %>" class="<% out.print(color_personal[0]);%> subject database" 
												style="text-align:center;vertical-align: middle;" id="database_<% out.print(subject[0]); %>" data-toggle="modal" data-target="#personal_modal_<% out.print(subject[0]);%>">				
												<%= subject[1] %>
												</td>
												<%
												number_personal++;
												%>
												<!-- Modal -->
												<div id="personal_modal_<% out.print(subject[0]);%>" class="modal fade" role="dialog">
												  <div class="modal-dialog">
												    <!-- Modal content-->
												    <div class="modal-content">
												      <div class="modal-header">
												        <button type="button" class="close" data-dismiss="modal">&times;</button>
												        <h4 class="modal-title"><b><% out.print(subject[1]);%></b></h4>
												      </div>
												      <div class="modal-body">
												        <p><b>Tên hoạt động: </b><% out.print(subject[1]);%></p>
												        <p><b>Ngày: </b><% out.print(subject[2]);%></p>
												        <p><b>Địa điểm: </b><% out.print(subject[3]);%></p>
												        <p><b>Tiết bắt đầu: </b><% out.print(subject[4]);%></p>
												        <p><b>Kéo dài: </b><% out.print(subject[6]);%> tiết</p>
												      </div>
												      <div class="modal-footer">
												      	<form action="PersonalDelete.jsp" method="POST" style="float:left">
															<input type="text" name="id" value="<%= subject[0] %>" hidden> 
															<input type="text" name="username" value="<%= username %>" hidden> 
															<input type="password" name="password" value="<%= password %>" hidden>
															<button type="submit" class="btn btn-danger">
															 	Xóa hoạt động <span class="glyphicon glyphicon-trash"></span>
															</button>
														</form>
														<form action="PersonalUpdateForm.jsp" method="POST" style="float:left">
															<input type="text" name="id" value="<%= subject[0] %>" hidden> 
															<input type="text" name="username" value="<%= username %>" hidden> 
															<input type="password" name="password" value="<%= password %>" hidden>
															<button type="submit" class="btn btn-success">
															 	Sửa hoạt động <span class="glyphicon glyphicon-edit"></span>
															</button>
														</form>
												        <button type="button" class="btn btn-warning" data-dismiss="modal">Close <span class="glyphicon glyphicon-remove"></button>
												      </div>
												    </div>
												  </div>
												</div>
												<%
											} else {
												String[] subject = vnu.getSubjectDetail(id);
												/* System.out.println(Integer.parseInt(subject[0])%3); */
												%>
												<td rowspan="<% out.print(span);%>" class="<% out.print(color_school[Integer.parseInt(subject[0])%3]);%> subject"
												 style="text-align:center;vertical-align: middle;" data-toggle="modal" data-target="#vnu_modal_<% out.print(subject[0]);%>">
												<% out.print(subject[2]); %>
												</td>
												<%												
												number_school++;
												%>
												<!-- Modal -->
												<div id="vnu_modal_<% out.print(subject[0]);%>" class="modal fade" role="dialog">
												  <div class="modal-dialog">
												    <!-- Modal content-->
												    <div class="modal-content">
												      <div class="modal-header">
												        <button type="button" class="close" data-dismiss="modal">&times;</button>
												        <h4 class="modal-title"><b><% out.print(subject[2]);%></b></h4>
												      </div>
												      <div class="modal-body">
												        <p><b>Mã môn học: </b><% out.print(subject[1]);%></p>
												        <p><b>Số tín chỉ: </b><% out.print(subject[3]);%></p>
												        <p><b>Trạng thái: </b><% out.print(subject[4]);%></p>
												        <p><b>Ngày học: </b><% out.print(subject[5]);%></p>
												        <p><b>Tiết: </b><% out.print(subject[6]);%></p>
												      </div>
												      <div class="modal-footer">
												        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
												      </div>
												    </div>
												  </div>
												</div>
											<%
											}
										}
									}
								}
							%></tr><%
						}
						%>
					</table>
				  </div>
				<%
					} catch (Exception e) {
						// Exception handler code here
					}
				%>
			</div>
			</div>
		</div>
	</div>
</body>

<script>
	$(function(){
		
		localStorage.setItem("ma_sv", "<%= username %>");
		localStorage.setItem("name", "<%= vnu.name %>");
		localStorage.setItem("user_id", "<%= user_id %>");
		
		$(".database").on("click",function(){
			//alert("Hello");
		});
	});
</script>

</html>