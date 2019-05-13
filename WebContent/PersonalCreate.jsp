<%@page import="DB.PersonalData"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ page import="VNU.VnuData"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
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
		request.setCharacterEncoding("UTF-8");
		String id = request.getParameter("id");
		String name = request.getParameter("name");
		String date = request.getParameter("date");
		String place = request.getParameter("place");
		String start = request.getParameter("start");
		String periods = request.getParameter("periods");
		String note = request.getParameter("note");
		
		PersonalData db = new PersonalData();
		
		db.add_pesonal_data(Integer.parseInt(id), name, date, place, Integer.parseInt(start),Integer.parseInt(periods));

		String username = request.getParameter("username");
		String password = request.getParameter("password");
	%>

	<form action="Calendar.jsp?offset=0" method="POST" hidden>
		<input type="text" name="username" value="<%=username%>"> 
		<input type="password" name="password" value="<%=password%>">
		<input type="submit" id="submit">
	</form>
	<script>
		$(function() {
			$('#submit').click();
		});
	</script>
</body>
</html>