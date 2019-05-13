<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
		int user_id = Integer.parseInt(request.getParameter("id"));
	%>
	<div class="limiter">
		<div class="container-login100">
			<div class="wrap-login100" style="width: 1200px !important">
				<h2>Tạo mới hoạt động</h2><br>
				<form action="PersonalCreate.jsp" method="POST" class="form_db">
					<div class="form-group" hidden>
						<label class="control-label" for="email">Tên:</label> 
						<input type="text" name="username" value="<%= username %>" >
						<input type="text" name="password" value="<%= password %>"> 
						<input type="text" class="form-control" name="id" value="<%= user_id %>">
					</div>
					<div class="form-group">
						<label class="control-label" for="email">Tên:</label> <input
							type="text" class="form-control" name="name"
							placeholder="Nhập tên công việc">
					</div>
					<div class="form-group">
						<label class="control-label" for="email">Ngày :</label> <input
							type="date" class="form-control" name="date" placeholder="Nhập ngày" format="dd/mm/yyyy">
					</div>
					<div class="form-group">
						<label class="control-label" for="email">Địa điểm:</label> 
						<input type="text" class="form-control" name="place" placeholder="Nhập địa điểm">
					</div>
					<div class="form-group">
						<label class="control-label" for="email">Bắt đầu vào tiết:</label>
						<input type="number" class="form-control" name="start" placeholder="Nhập thời điểm bắt đầu">
					</div>
					<div class="form-group">
						<label class="control-label" for="email">Kéo dài đến tiết:</label>
						<input type="number" class="form-control" name="periods" placeholder="Nhập thời gian kéo dài">
					</div>
					<button type="submit" class="btn btn-info">Submit</button>
				</form>
			</div>
		</div>
	</div>
</body>
</html>