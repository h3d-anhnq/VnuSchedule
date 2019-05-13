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
<link rel="stylesheet" type="text/css" href="css/vnuChat.css">
<link rel="stylesheet" type="text/css" href="css/jquery_ui.css">
<script src="js/jquery-3.3.1.min.js"></script>
<script src="js/socket.io-2.1.1.js"></script>
<script src="js/jquery-ui.js"></script>
</head>
<body>
	<div class="limiter">
		<div class="container-login100">
			<div class="wrap-login100" style="width: 1200px !important">
				<!-- <h2>
					<b>VNU Chat</b> <span id="name"></span>
				</h2> -->
				<table style="width: 100%">
					<tr>
						<td>
							<h2>
								<b>VNU Chat</b> <span id="name"></span>
							</h2>
						</td>
						<td>
							<div class="row">
								<div class="col-md-7">
									<input type="text" class="form-control" id="find_friends" />
								</div>
								<div class="col-md-5">
									<button class="btn btn-danger" id="btn_add_friend">Add to friend list</button>
								</div>
							</div>
						</td>
					</tr>
				</table>
				<br>
				<div class="messaging">
					<div class="inbox_msg">
						<div class="inbox_people">
							<div class="inbox_chat scroll" id="online_area"></div>
						</div>

						<div class="mesgs">
							<div class="msg_history" id="message_area"></div>
							<div class="type_msg">
								<div class="input_msg_write">
									<input id="send_message_area" type="text" class="write_msg"
										placeholder="Type a message" />
									<button class="msg_send_btn" type="button" id="send_mess_btn">
										<span class="glyphicon glyphicon-send"></span>
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>

<script type="text/javascript">
	//Create new socket
	var socket = io.connect('http://localhost:6969');
	//State when start or not
	var start = false;
	//Current chat friend id
	var current_friend_id = -1;
	//Remove space at the beginning
	function left_trim(str) {
		if (str == null)
			return str;
		return str.replace(/^\s+|\s+$/g, '');
	}
	//Remove space at the end
	function right_trim(str) {
		if (str == null)
			return str;
		return str.replace(/\s+$/g, '');
	}

	$(function() {
		$('#name').html(" - " + localStorage.name + " - " + localStorage.ma_sv);
		//Register to the server
		socket.emit('register', [ localStorage.name, localStorage.ma_sv,
				localStorage.user_id ]);

		socket.emit('get_auto_complete_data');

		$('.inbox_chat').on('click', '.friend', function() {
			//Friend id
			var friend_id = this.id.split("_")[1];
			//Request message from the server
			socket.emit('get_message_from_a_friend', friend_id);
			//Update current friend id
			current_friend_id = friend_id;
		});
		
		$('.inbox_chat').on('click','.friend_request',function(){
			//Friend id
			var friend_id = this.id.split("/")[1];
			var friend_name = this.id.split("/")[2];
			
			var r = confirm("Chấp nhận lời mời kết bạn từ "+friend_name);
			if (r) {
				socket.emit('accept_friend_request',friend_id);
			}
			
			this.remove();
		});

		$('#send_message_area').keyup(function(e) {
			if (e.keyCode == 13) {
				send_message_to_friend();
				$('#send_message_area').val("");
			}
		});

		$('#send_mess_btn').on('click', function() {
			send_message_to_friend();
			$('#send_message_area').val("");
		});
		
		$('#btn_add_friend').on('click', function() {
			//socket.emit('add_friend_to_friend_list',$('#find_friends').val());
			socket.emit('add_friend_to_friend_list_request',$('#find_friends').val());
			$('#find_friends').val("");
		});
	});

	function add_incoming_msg(message, date) {
		var str = '<div class="incoming_msg">' + '<div class="received_msg">'
				+ '<div class="received_withd_msg">' + '<p>' + message + '</p>'
				+ '<span class="time_date">' + date + '</span></div>'
				+ '</div>' + '</div>' + '</div>';
		$('#message_area').append(str);
	}

	function add_outcoming_msg(message, date) {
		var str = '<div class="outgoing_msg">' + '<div class="sent_msg">'
				+ '<p>' + message + '</p>' + '<span class="time_date">' + date
				+ '</span></div>' + '</div>' + '</div>';
		$('#message_area').append(str);
	}

	function add_user_online(data) {
		var str = '<div class="chat_list friend" id="friend_'+ data[2] +'">'
				+ '<div class="chat_people">'
				+ '<div class="chat_img"> <img src="https://www.vnu.edu.vn/upload/2014/11/17202/vnu_branding_logo_01.jpg" alt="sunil"> </div>'
				+ '<div class="chat_ib">' + '<h5>' + data[0] + " - " + data[1]
				+ '</h5>' + '<p>Online</p>' + '</div>' + '</div>' + '</div>';
		$('#online_area').append(str);
	}
	
	function add_incoming_friend_request(data) {
		var str = '<div class="chat_list friend_request" id="friend_request_/'+ data[2] + "/"+ data[0] +'/">'
				+ '<div class="chat_people">'
				+ '<div class="chat_img"> <img src="https://image.flaticon.com/icons/png/512/179/179386.png" alt="sunil"> </div>'
				+ '<div class="chat_ib">' + '<h5>New friend request!' 
				+ '</h5>' + '<p>'+data[0] + " - " + data[1]+'</p>' + '</div>' + '</div>' + '</div>';
		$('#online_area').prepend(str);
	}

	function convertISOstring(iso_str) {
		date = iso_str.split("T")[0].split("-");
		time = iso_str.split("T")[1].split(":");
		year = date[0];
		month = date[1];
		day = date[2];
		hour = time[0];
		min = time[1];
		return hour + ":" + min + "    |    " + day + "/" + month + "/" + year;
	}

	function send_message_to_friend() {
		var value = left_trim(right_trim($('#send_message_area').val()));
		if (current_friend_id == -1) {
			alert("Please choose a friend to send message");
		} else {
			if (this.value != "" && value.replace(/\s/g, '').length) {
				socket.emit('send_message_to_a_friend', [ value,
						current_friend_id ]);
			}
		}

	}

	//Called when the server call socket.emit("update_friend_online")
	socket.on('update_friend_online', function(data) {
		$('#online_area').html("");
		for (var i = 0; i < data.length; i++) {
			add_user_online(data[i]);
		}
	});

	//Called when the server call socket.emit("update_auto_complete")
	socket.on('update_auto_complete', function(data) {
		$("#find_friends").autocomplete({
			source : data
		});
	});
	
	//Called when the server call socket.emit("incoming_friend_request")
	socket.on('incoming_friend_request', function(data) {
		console.log("incoming_friend_request");
		console.log(data);
		add_incoming_friend_request(data);
	});
	
	//Called when the server call socket.emit("update_message")
	socket.on('update_message', function(data_mess) {
		if( data_mess[1] == current_friend_id ){
			var data = data_mess[0];
			$('#message_area').html("");
			var user_id = localStorage.user_id;
			for (var i = data.length - 1; i >= 0; i--) {
				if (data[i].from_id == user_id) {
					add_outcoming_msg(data[i].message,
							convertISOstring(data[i].send_at));
				} else {
					add_incoming_msg(data[i].message,
							convertISOstring(data[i].send_at));
				}
			}
			var objDiv = document.getElementById("message_area");
			objDiv.scrollTop = objDiv.scrollHeight;
		}
	});
</script>

</html>