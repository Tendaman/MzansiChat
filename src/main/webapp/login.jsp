<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Login</title>
  <link rel="stylesheet" href="styles.css">

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
    .login-container {
      text-align: center;
      background-color: white;
      padding: 40px;
      display: flex;
      flex-direction: column;
      border-radius: 8px;
      box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.1);
    }
    .login-container h1 {
      color: #00b4d8;
      margin-bottom: 20px;
    }
    input[type="text"], input[type="password"] {
      width: 90%;
      padding: 12px;
      display: block;
      margin: 15px 0;
      border: 1px solid #ddd;
      border-radius: 8px;
    }
    .btn {
      background-color: #00b4d8;
      color: white;
      padding: 12px;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      width: fit-content;
      margin-top: 10px;
    }
    .btn:hover {
      background-color: #0096c7;
    }
    .error-message {
      color: red;
      margin-top: 10px;
    }
  </style>

</head>
<body>

<div class="login-container">
  <h1>Mzansi Chat Zone</h1>
  <form action="login" method="post">
    <input type="text" name="username" placeholder="Username" required>
    <input type="password" name="password" placeholder="Password" required>
      <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null) {
      %>
    <div class="error-message"><%= errorMessage %></div>
      <%
        }
      %>
    <button type="submit" class="btn">Login</button>
  </form>
  <form action="register.jsp" method="get">
    <button type="submit" class="btn">Register</button>
  </form>
</div>
</body>
</html>
