<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="org.example.chatapp2.model.User" %>
<%@ page import="org.example.chatapp2.model.Message" %>
<%@ page import="org.example.chatapp2.dao.MessageDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Fetch last messages in conversations
    List<Message> lastMessages = MessageDAO.getLastMessages(user.username());
    Map<String, Message> conversations = new LinkedHashMap<>();

    // Organize conversations by the username of the other participant
    for (Message message : lastMessages) {
        String otherUser = message.getSender().equals(user.username()) ? message.getReceiver() : message.getSender();
        conversations.put(otherUser, message);
    }

    // Create a SimpleDateFormat to format the timestamp
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chat Conversations</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        .home-container {
            text-align: center;
            background-color: #dbdbdb;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 600px; /* Max width for larger screens */
            height: auto;
            margin: 20px auto; /* Centered horizontally */
            padding: 20px;
            box-sizing: border-box;
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
        }
        ul {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }
        li {
            background-color: #fff;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
            display: flex; /* Use flexbox for alignment */
            align-items: center; /* Align items vertically */
            cursor: pointer;
            flex-direction: column; /* Stack items vertically for smaller screens */
        }
        li a {
            text-decoration: none;
            color: #333;
            width: 100%;
            display: flex;
            justify-content: space-between; /* Space between username and message */
            align-items: center; /* Center items vertically */
        }
        li a:hover {
            text-decoration: none;
        }
        li .last-message {
            font-size: 12px;
            color: #777;
        }
        a.back-button {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #00b4d8;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            display: inline-block; /* Adjust display for better alignment */
        }
        a.back-button:hover {
            background-color: #0096c7;
        }
        .username {
            font-weight: bold;
            text-align: left;
            margin-right: auto;
        }
        .last-message {
            font-size: 12px;
            color: #777;
            text-align: right;
            margin-left: auto; /* Pushes the last message to the end of the container */
        }
        .message-status {
            font-size: 12px;
            color: #999;
            display: block; /* Ensure it is on a new line */
            position: relative;
            margin-top: 10px;
            left: 0; /* Stick to the absolute left of the box */
        }
        .timestamp {
            font-size: 10px;
            color: #aaa;
            text-align: right;
            display: block;
            margin-top: 10px;
        }
        /* Responsive Design */
        @media (max-width: 768px) {
            .home-container {
                width: 95%;
                padding: 15px;
            }
            li {
                padding: 8px;
            }
        }

        @media (max-width: 480px) {
            h1 {
                font-size: 1.5em;
            }
            .home-container {
                width: 100%;
                border-radius: 0; /* Remove border radius for small screens */
                box-shadow: none; /* Remove shadow for small screens */
            }
            li {
                flex-direction: column; /* Ensure items stack vertically */
                padding: 10px;
            }
            .username {
                font-size: 1.2em; /* Increase font size for readability */
            }
        }
    </style>
</head>
<body>
<div class="home-container">
<h2>Conversations</h2>
<% if (!conversations.isEmpty()) { %>
<ul>
    <% for (Map.Entry<String, Message> conversation : conversations.entrySet()) {
        Message message = conversation.getValue();
        Date timestamp = message.getTimestamp(); // Get the timestamp
        String formattedTime = timeFormat.format(timestamp); // Format to HH:mm
    %>
    <li>
        <a href="chat.jsp?username=<%= conversation.getKey() %>">
            <div class="username">
                <span><%= conversation.getKey() %></span>
                <span class="message-status"><%= message.getSender().equals(user.username()) ? "Sent" : "Received" %></span>
            </div>

            <div class="last-message">
                <span><%= message.getContent() %></span>
                <span class="timestamp"><%= formattedTime %></span>
            </div>
        </a>
    </li>
    <% } %>
</ul>
<% } else { %>
<p>You have no conversations yet.</p>
<% } %>

<a href="javascript:void(0);" class="back-button" onclick="history.back();">Back</a>
</div>
</body>
</html>
