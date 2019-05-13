<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Đăng nhập</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" type="image/png" href="images/icons/favicon.ico" />
<link rel="stylesheet" type="text/css" href="css/util.css">
<link rel="stylesheet" type="text/css" href="css/main.css">
</head>
<body>
	<div class="limiter">
		<div class="container-login100">
			<div class="wrap-login100">
				<form class="login100-form validate-form" action="Calendar.jsp?offset=0" method="POST">
					<span class="login100-form-title p-b-26"> Đăng nhập </span> <span
						class="login100-form-title p-b-48"> <img
						src="images/icons/vnu-logo.jpg">
					</span>

					<div class="wrap-input100 validate-input">
						<input class="input100" type="text" name="username" required value="16001742"> 
						<!-- <input class="input100" type="text" name="username" required>  -->
						<span class="focus-input100" data-placeholder="Mã sinh viên"></span>
					</div>

					<div class="wrap-input100 validate-input"
						data-validate="Enter password">
						<span class="btn-show-pass"> <i class="zmdi zmdi-eye"></i></span>
						<input class="input100" type="password" name="password" required value="25111998">
						<!--<input class="input100" type="password" name="password" required>  -->
						<span class="focus-input100" data-placeholder="Mật khẩu"></span>
					</div>

					<div class="container-login100-form-btn">
						<div class="wrap-login100-form-btn">
							<div class="login100-form-bgbtn"></div>
							<button class="login100-form-btn" type="submit">Đăng nhập</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	<script src="js/main.js"></script>
</body>
</html>
