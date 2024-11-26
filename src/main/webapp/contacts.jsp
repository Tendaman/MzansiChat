<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.example.chatapp2.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.chatapp2.dao.UserDAO" %>
<%
  User loggedInUser = (User) session.getAttribute("user");
  if (loggedInUser == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  List<User> users = UserDAO.getAllUsers();
%>
<html>
<head>
  <title>Contacts</title>
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
      display: flex;
      align-items: center;
      cursor: pointer;
      flex-direction: column; /* Stack items vertically for smaller screens */
    }
    li a {
      text-decoration: none;
      color: #333;
      width: 100%;
      display: flex;
      flex-direction: column; /* Stack username and name vertically */
      align-items: flex-start;
    }
    li a:hover {
      text-decoration: none;
    }
    .username {
      font-weight: bold;
      text-align: left;
      margin-right: auto;
    }
    .name {
      color: #666;
      font-size: 0.9em;
      text-align: left;
    }
    a.back-to-home {
      margin-top: 20px;
      padding: 10px 20px;
      background-color: #00b4d8;
      color: white;
      text-decoration: none;
      border-radius: 4px;
      display: inline-block; /* Adjust display for better alignment */
    }
    a.back-to-home:hover {
      background-color: #0096c7;
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
      .name {
        font-size: 1em; /* Increase font size for readability */
      }
    }
  </style>
</head>
<body>
<div class="home-container">
  <h1>Available Contacts</h1>

  <% if (!users.isEmpty()) { %>
  <ul>
    <% for (User contact : users) { %>
    <li>
      <a href="chat.jsp?username=<%= contact.username() %>">
        <div class="username">
          <%= contact.username() %>
        </div>
        <div class="name">
          <%= contact.name() %>
        </div>
      </a>
    </li>
    <% } %>
  </ul>
  <% } else { %>
  <p>No users available.</p>
  <% } %>

  <a href="javascript:void(0);" class="back-to-home" onclick="history.back();">Back</a>
</div>

</body>
</html>
