var express = require('express');
var app = express();
app.use(express.static('public'));
var http = require('http').Server(app);
var port = process.env.PORT || 6969;

var mysql = require('mysql');

var con = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "itplus_end"
});

con.connect();

//Listen to the given port
http.listen(port, function () {
    console.log("Listening on * " + port);
});

//Setup socket server
var io = require('socket.io')(http);

var client_online = {};

//When have a connection
io.on('connection', function (socket) {
    //Log new client
    console.log("New client at " + socket.id);
    //Call when the client call socket.emit('register', _);
    socket.on('register', function (data) {
        client_online[socket.id] = data;
        Object.keys(client_online).forEach(
            (key) => {
                var soc = client_online[key];
                getFriendsOnline(con, soc[2], key);
            }
        );
    });

    //Call when the client call socket.emit('get_message', _);
    socket.on('get_message_from_a_friend', function (friend_id) {
        var client_id = client_online[socket.id][2];
        getMessageWithOneFriend(con, client_id, friend_id, socket.id);
    });

    //Call when someone disconnect
    socket.on('disconnect', function () {
        delete client_online[socket.id];
        Object.keys(client_online).forEach(
            (key) => {
                var soc = client_online[key];
                getFriendsOnline(con, soc[2], key);
            }
        );
    });

    function getFriendsOnline(con, client_id, socket_id) {
        con.query("SELECT * FROM friends WHERE user_id_1=" + client_id + " OR user_id_2=" + client_id, function (err, result, fields) {
            var friendsOnline = [];
            if (result != null) {
                for (let index = 0; index < result.length; index++) {
                    const element = result[index];
                    if (client_id == element.user_id_1) {
                        Object.keys(client_online).forEach(
                            (key) => {
                                if (client_online[key][2] == element.user_id_2) {
                                    friendsOnline.push(client_online[key]);
                                }
                            }
                        );
                    } else {
                        Object.keys(client_online).forEach(
                            (key) => {
                                if (client_online[key][2] == element.user_id_1) {
                                    friendsOnline.push(client_online[key]);
                                }
                            }
                        );
                    }
                }
            }
            io.to(socket_id).emit('update_friend_online', friendsOnline);
        });
    }

    function getMessageWithOneFriend(con, client_id, friend_id, socket_id) {
        var query_str = "SELECT * FROM message WHERE (from_id=" + client_id + " AND to_id=" + friend_id + ")" +
            "OR (from_id=" + friend_id + " AND to_id=" + client_id + ") ORDER BY send_at DESC limit 10";
        con.query(query_str, function (err, result, fields) {
            io.to(socket_id).emit('update_message', [result,friend_id]);
        });
    }

    function sendMessageToAFriend(con, from_id, to_id, message) {
        var date = new Date();
        var finalDate = date.toISOString().split('T')[0] + ' ' + date.toTimeString().split(' ')[0];
        var query = "INSERT INTO message (`from_id`, `to_id`, `message`, `send_at`) VALUES ?";
        var values = [
            [from_id, to_id, message, finalDate]
        ];
        con.query(query, [values], function (err, result) {
            if (err) {
                console.log(err);
            }
            Object.keys(client_online).forEach(
                (key) => {
                    var soc = client_online[key];
                    if (soc[2] == from_id) {
                        getMessageWithOneFriend(con, from_id, to_id, key);
                    } else if (soc[2] == to_id) {
                        getMessageWithOneFriend(con, to_id, from_id, key);
                    }
                }
            );
        });
    }

    function getAutoCompleteUsersData(client_id,socket_id) {
        var query_str = "SELECT * FROM users WHERE id != " + client_id;
        con.query(query_str, function (err, result, fields) {
            var data = [];
            if (result != null) {
                for (let index = 0; index < result.length; index++) {
                    const element = result[index];
                    var str = element.name + "-" + element.ma_sv;
                    data.push(str);
                }
            }
            io.to(socket_id).emit('update_auto_complete', data);
        });
    }

    //Call when the client call socket.emit('get_message', _);
    socket.on('get_auto_complete_data', function () {
        var client_id = client_online[socket.id][2];
        getAutoCompleteUsersData(client_id,socket.id);
    });

    //Call when the client call socket.emit('get_message', _);
    socket.on('add_friend_to_friend_list', function (data) {
        var client_id = client_online[socket.id][2];
        var friend_name = data.split("-")[0];
        var friend_ma_sv = data.split("-")[1];
        var query_str = "SELECT id FROM users WHERE name = '" + friend_name + "' AND ma_sv = " + friend_ma_sv;
        con.query(query_str, function (err, result, fields) {
            var friend_id = result[0].id;
            var query = "INSERT INTO `friends`(`user_id_1`, `user_id_2`) VALUES ?";
            var values = [
                [client_id, friend_id]
            ];
            con.query(query, [values], function (err, result) {
                if (err) {
                    console.log(err);
                }
                getFriendsOnline(con,client_id,socket.id);

                Object.keys(client_online).forEach(
                    (key) => {
                        var soc = client_online[key];
                        if (soc[2] == friend_id) {
                            getFriendsOnline(con, soc[2], key);
                        }
                    }
                );
            });
        });
    });

    function send_incoming_friend_request(data,socket_id) {
        io.to(socket_id).emit('incoming_friend_request', data);
    }

    //Call when the client call socket.emit('get_message', _);
    socket.on('add_friend_to_friend_list_request', function (data) {
        var friend_name = data.split("-")[0];
        var friend_ma_sv = data.split("-")[1];
        var query_str = "SELECT id FROM users WHERE name = '" + friend_name + "' AND ma_sv = " + friend_ma_sv;
        con.query(query_str, function (err, result, fields) {
            var friend_id = result[0].id;
            Object.keys(client_online).forEach(
                (key) => {
                    var soc = client_online[key];
                    if (soc[2] == friend_id) {
                        send_incoming_friend_request(client_online[socket.id],key);
                    }
                }
            );
        });
    });

    //Call when the client call socket.emit('get_message', _);
    socket.on('accept_friend_request', function (data) {
        var friend_id = data;
        var client_id = client_online[socket.id][2];
        var query = "INSERT INTO `friends`(`user_id_1`, `user_id_2`) VALUES ?";
        var values = [
            [client_id, friend_id]
        ];
        con.query(query, [values], function (err, result) {
            if (err) {
                console.log(err);
            }
            getFriendsOnline(con, client_id, socket.id);

            Object.keys(client_online).forEach(
                (key) => {
                    var soc = client_online[key];
                    if (soc[2] == friend_id) {
                        getFriendsOnline(con, soc[2], key);
                    }
                }
            );
        });
    });

    //Call when the client call socket.emit('get_message', _);
    socket.on('send_message_to_a_friend', function (data) {
        var client_id = client_online[socket.id][2];
        var friend_id = data[1];
        var message = data[0];
        sendMessageToAFriend(con, client_id, friend_id, message);
    });
});