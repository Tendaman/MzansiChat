<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.chatapp2.model.Message" %>
<%@ page import="org.example.chatapp2.dao.MessageDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.chatapp2.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String receiver = request.getParameter("username");
    if (receiver == null || receiver.trim().isEmpty()) {
        response.sendRedirect("contacts.jsp");
        return;
    }

    List<Message> messages = MessageDAO.getMessages(loggedInUser.username(), receiver);

    // Create a SimpleDateFormat to format the timestamp
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat with <%= receiver %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .chat-box {
            width: 96%;
            height: 300px;
            overflow-y: scroll;
            border: 1px solid #ccc;
            padding: 10px;
            background-color: #fff;
            margin-bottom: 20px;
        }
        .message {
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 4px;
        }
        .sent {
            background-color: #00b4d8;
            color: white;
            text-align: right;
            float: right;
            clear: both;
            border-radius: 4px;
            padding: 10px;
            margin-bottom: 10px;
            max-width: 60%;
        }
        .received {
            background-color: #e0e0e0;
            color: black;
            text-align: left;
            float: left;
            clear: both;
            border-radius: 4px;
            padding: 10px;
            margin-bottom: 10px;
            max-width: 60%;
        }

        .sent1 {
            background-color: transparent;
            text-align: right;
            float: right;
            clear: both;
            margin-bottom: 10px;
            max-width: 60%;
        }
        .received1 {
            background-color: transparent;
            text-align: left;
            float: left;
            clear: both;
            margin-bottom: 10px;
            max-width: 60%;
        }
        .home-container {
            text-align: center;
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            width: 50%;
            height: fit-content;
            padding: 20px;
            position: relative;
        }

        form {
            display: flex;
        }
        input[type="text"] {
            flex-grow: 1;
            padding: 10px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }
        input[type="submit"] {
            padding: 10px;
            background-color: #00b4d8;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 10px;
        }
        input[type="submit"]:hover {
            background-color: #0096c7;
        }
        .timestamp {
            display: block;
            font-size: 0.8em;
            color: #888;
        }

        .input-container {
            position: relative;
            display: flex;
            align-items: center;
            width: 100%;
            border-radius: 20px;
            border: 1px solid #ccc;
            background-color: #fff;
        }

        .input-container input[type="text"] {
            flex-grow: 1;
            border: none;
            outline: none;
            border-radius: 20px;
            font-size: 14px;
            margin-right: 10px;
        }

        .input-container .camera-btn {
            background: none;
            border: none;
            padding: 0;
            cursor: pointer;
            display: flex;
            align-items: center;
        }

        .input-container .camera-btn img {
            width: 40px;
            height: 40px;
            display: block;
        }


        a.back-button {
            padding: 10px;
            background-color: #00b4d8;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 30px;
            text-decoration: none;
            text-align: center;
            display: inline-block;
            font-size: 14px;
        }


        a.back-button:hover {
            background-color: #0096c7;
        }

        a.back-button {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #00b4d8;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }

    </style>
</head>
<body>

<div class="home-container">
<h1>Chat with <%= receiver %></h1>

<div class="chat-box" id="chatBox">
    <% for (Message message : messages) {
        Date timestamp = message.getTimestamp(); // Get the timestamp
        String formattedTime = timeFormat.format(timestamp); // Format to HH:mm
    %>
    <div class="message <%= message.getSender().equals(loggedInUser.username()) ? "sent" : "received" %>">
        <%= message.getContent() %>

    </div>
    <div class="timestamp <%= message.getSender().equals(loggedInUser.username()) ? "sent1" : "received1" %>">
        <%= formattedTime %> <!-- Display only hours and minutes -->
    </div>
    <% } %>

</div>

<form id="chatForm">
    <input type="hidden" name="receiver" value="<%= receiver %>" />
    <div class="input-container">
        <input type="text" id="messageInput" placeholder="Type a message..." />
        <button type="button" class="camera-btn" id="cameraButton">
            <i class="fa fa-camera" style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); cursor: pointer;"></i>
        </button>
    </div>
    <input type="submit" value="Send" />
</form>



<a href="javascript:void(0);" class="back-button" onclick="handleBackButton();">Back</a>
</div>
<script>
window.onload = function() {
    const username = "<%= loggedInUser.username() %>";
    const receiver = "<%= receiver %>";
    const chatBox = document.getElementById("chatBox");
    const messageInput = document.getElementById("messageInput");
    const chatForm = document.getElementById("chatForm");

    // Replace with your WebSocket URL
    const socket = new WebSocket("ws://localhost:8080/chatapp2-1.0-SNAPSHOT/chat");

    socket.onmessage = function(event) {
        const message = JSON.parse(event.data);
        const messageElement = document.createElement("div");
        const timestampElement = document.createElement("div");

        messageElement.className = message.sender === username ? "message sent" : "message received";
        messageElement.textContent =  message.content;

        // Create timestamp element
        timestampElement.className = message.sender === username ? "timestamp sent1" : "timestamp received1";
        timestampElement.textContent = new Date(message.timestamp).toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});

        chatBox.appendChild(messageElement);
        chatBox.appendChild(timestampElement);
        chatBox.scrollTop = chatBox.scrollHeight;
    };

    socket.onerror = function(event) {
        console.error("WebSocket error observed:", event);
    };

    socket.onclose = function(event) {
        console.log("WebSocket is closed now.", event);
    };

    chatForm.onsubmit = function(event) {
        event.preventDefault();

        const content = messageInput.value.trim();
        if (content === "") {
            return; // Do nothing if the message is empty
        }

        const message = {
            sender: username,
            receiver: receiver,
            content: messageInput.value,
            timestamp: new Date().toISOString() // Send current timestamp
        };

        const messageElement = document.createElement("div");
        const timestampElement = document.createElement("div");
        messageElement.className = "message sent";
        messageElement.textContent = message.content;

        // Create timestamp element
        timestampElement.className = "timestamp sent1";
        timestampElement.textContent = new Date(message.timestamp).toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});

        chatBox.appendChild(messageElement);
        chatBox.appendChild(timestampElement);
        chatBox.scrollTop = chatBox.scrollHeight;

        socket.send(JSON.stringify(message));
        messageInput.value = "";
    };

    document.getElementById('cameraButton').addEventListener('click', function() {
        history.replaceState(null, null, location.href);
        window.location.href = 'camera.jsp?receiver=<%= receiver %>';
    });
};

// Handle back button click
function handleBackButton() {
    const referrer = document.referrer;
    if (referrer.includes('camera.jsp')) {
        history.go(-2); // Go back two steps in history
    } else {
        history.back(); // Go back one step in history
    }
}
</script>
</body>
</html>
