<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="jakarta.servlet.http.HttpServletRequest" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>
<%@ page import="org.example.chatapp2.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Handle null case
    Integer unreadMessagesCount = (Integer) request.getAttribute("unreadMessagesCount");
    if (unreadMessagesCount == null) {
        unreadMessagesCount = 0;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home</title>
    <link rel="stylesheet" href="styles.css">

    <style>
        body{
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .home-container {
            text-align: center;
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            width: 40%;
            height: 80%;
            position: relative;
        }
        .home-container img.profile-img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin-top: 10px;
            border: 4px solid #fff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .head-container h2 {
            color: #fff;
            margin-top: 10px;
            font-size: 24px;
        }
        .head-container p {
            color: #fff;
            margin-top: 5px;
            font-size: 16px;
        }
        .notification-icon, .settings-icon {
            width: 20px;
            height: 20px;
            position: absolute;
            top: 20px;
        }
        .notification-icon {
            left: 20px;
        }
        .settings-icon {
            right: 20px;
        }
        .btn {
            background-color: #fff;
            color: #000;
            padding: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            margin-top: 10px;
            margin-bottom: 10px;
            text-align: left;
            padding-left: 20px;
            font-weight: bold;
        }
        .btn:hover {
            background-color: #00b4d8;
            color: #fff;
        }
        .btn span {
            background-color: #ea580c;
            color: white;
            border-radius: 12px;
            padding: 2px 8px;
            font-size: 12px;
            margin-left: 10px;
        }
        .new-chat-btn {
            background-color: #00b4d8;
            color: white;
            border-radius: 30px;
            width: fit-content;
            padding: 15px;
            font-size: 18px;
            position: absolute;
            text-align: center;
            bottom: 5px;
            left: 50%;
            transform: translateX(-50%);
            border: none;
            cursor: pointer;
            margin-bottom: 20px;
        }
        .new-chat-btn:hover {
            background-color: #0096c7;
        }
        .head-container{
            height: fit-content;
            background-color: #007BFF;
            width: 100%;
            padding-bottom: 20px;
            margin-bottom: 10px;
            border-bottom-left-radius: 10px;
            border-bottom-right-radius: 10px;
            border: none;
        }
        @media (max-width: 768px) {
            .home-container {
                width: 90%;
                padding-bottom: 60px;
            }
            .btn {
                padding-left: 15px;
                font-size: 16px;
            }
            .new-chat-btn {
                width: fit-content;
                font-size: 16px;
                margin-bottom: 20px;
            }
        }

        @media (max-width: 480px) {
            .home-container {
                width: 95%;
                padding-bottom: 40px;
            }
            .btn {
                padding-left: 10px;
                font-size: 14px;
            }
            .new-chat-btn {
                width: fit-content;
                font-size: 14px;
                margin-bottom: 20px;
            }
        }
    </style>

</head>
<body>
<div class="home-container">
    <!-- Notification and Settings Icons -->
    <div class="head-container">
        <img src="https://img.icons8.com/?size=100&id=83193&format=png&color=000000" class="notification-icon" alt="Notifications">
        <img src="https://img.icons8.com/?size=100&id=2969&format=png&color=000000" class="settings-icon" alt="Settings">

        <!-- Profile Image -->
        <img src="https://img.icons8.com/?size=100&id=zxB19VPoVLjK&format=png&color=000000" class="profile-img" alt="Profile Image">

        <!-- User Info -->
        <h2>Hi, <%= user.username() %>!</h2>
        <!-- Display the new messages notification only if there are unread messages -->
        <% if (unreadMessagesCount > 0) { %>
        <p>You have <%= unreadMessagesCount %> new messages!</p>
        <% } %>
    </div>

    <!-- Buttons -->
    <button class="btn" onclick="location.href='conversation.jsp'">
        Conversations
        <% if (unreadMessagesCount > 0) { %>
        <span><%= unreadMessagesCount %></span>
        <% } %>
    </button>
    <button class="btn" onclick="location.href='contacts.jsp'">Contacts</button>
    <button class="btn" onclick="location.href='logout.jsp'">Sign out</button>

    <!-- New Chat Button -->
    <button class="new-chat-btn" onclick="location.href='contacts.jsp'">New Chat</button>
</div>
</body>
</html>
