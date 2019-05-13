<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="VNU.VnuData"%>
<%@ page import="DB.PersonalData"%>
<%@ page import="java.util.Arrays"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<!-- jQuery library -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<!-- Latest compiled JavaScript -->
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
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
		int id = Integer.parseInt(request.getParameter("id"));

		PersonalData pesonal = new PersonalData();
		//out.print(Arrays.toString(pesonal.get_data_by_id(id)));
		String[] data = pesonal.get_data_by_id(id);
	%>
	<div class="limiter">
		<div class="container-login100">
			<div class="wrap-login100" style="width: 1200px !important">
				<h2>Sửa đổi hoạt động</h2>
				<br>
				<form action="PersonalUpdate.jsp" method="POST" class="form_db">
					<div class="form-group" hidden>
						<label class="control-label" for="email">Tên:</label> <input
							type="text" name="username" value="<%=username%>"> <input
							type="text" name="password" value="<%=password%>"> <input
							type="number" name="id" value="<%=id%>">
					</div>
					<div class="form-group">
						<label class="control-label" for="email">Tên:</label> <input
							type="text" class="form-control" name="name"
							placeholder="Nhập tên công việc" value="<%= data[1] %>">
					</div>
					<div class="form-group">
						<label class="control-label" for="email">Ngày :</label> <input
							type="date" class="form-control" name="date"
							placeholder="Nhập ngày" format="dd/mm/yyyy" value="<%= data[2] %>">
					</div>
					<div class="form-group">
						<label class="control-label" for="email">Địa điểm:</label> <input
							type="text" class="form-control" name="place"
							placeholder="Nhập địa điểm" value="<%= data[3] %>">
					</div>
					<div class="form-group">
						<label class="control-label" for="email">Bắt đầu vào tiết:</label>
						<input type="number" class="form-control" name="start"
							placeholder="Nhập thời điểm bắt đầu" value="<%= data[4] %>">
					</div>
					<div class="form-group">
						<label class="control-label" for="email">Kéo dài đến tiết:</label>
						<input type="number" class="form-control" name="periods"
							placeholder="Nhập thời gian kéo dài" value="<%= data[5] %>">
					</div>
					<button type="submit" class="btn btn-info">Submit</button>
				</form>
			</div>
		</div>
	</div>
</body>
</html>