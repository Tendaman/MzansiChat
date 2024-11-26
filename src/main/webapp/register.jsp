<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Register</title>
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
    .register-container {
      text-align: center;
      background-color: white;
      display: flex;
      flex-direction: column;
      padding: 40px;
      border-radius: 8px;
      box-shadow: 0 0 10px 0 rgba(0,0,0,0.1);
    }
    .register-container h1 {
      color: #00b4d8;
      margin-bottom: 20px;
    }
    input[type="text"], input[type="password"], input[type="email"] {
      width: 90%;
      padding: 12px;
      display: block;
      margin: 15px 0;
      border: 1px solid #ddd;
      border-radius: 4px;
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
    .error {
      color: red;
      margin-top: 5px;
      display: none;
    }
  </style>

</head>
<body>

<div class="register-container">
  <h1>Mzansi Chat Zone</h1>
  <form action="register" method="post" onsubmit="return validateForm();">
    <input type="text" name="name" placeholder="Full Name">
    <div id="nameError" class="error">Full name is required.</div>

    <input type="text" name="username" placeholder="Username">
    <div id="usernameError" class="error">Username is required.</div>

    <input type="email" name="email" placeholder="Email">
    <div id="emailError" class="error"></div>

    <input type="password" name="password" placeholder="Password">
    <div id="passwordError" class="error">Password is required.</div>

    <button type="submit" class="btn">Register</button>
  </form>
  <form action="login.jsp" method="get">
    <button type="submit" class="btn">Login</button>
  </form>
</div>

<script>
  function validateForm() {
    let isValid = true;

    // Get form fields
    const nameField = document.querySelector('input[name="name"]');
    const usernameField = document.querySelector('input[name="username"]');
    const emailField = document.querySelector('input[name="email"]');
    const passwordField = document.querySelector('input[name="password"]');

    // Get error message elements
    const nameError = document.getElementById('nameError');
    const usernameError = document.getElementById('usernameError');
    const emailError = document.getElementById('emailError');
    const passwordError = document.getElementById('passwordError');

    // Clear previous error messages
    nameError.style.display = 'none';
    usernameError.style.display = 'none';
    emailError.style.display = 'none';
    passwordError.style.display = 'none';

    // Validate name
    if (nameField.value.trim() === '') {
      nameError.style.display = 'block';
      isValid = false;
    }

    // Validate username
    if (usernameField.value.trim() === '') {
      usernameError.style.display = 'block';
      isValid = false;
    }

    // Validate email
    const email = emailField.value;
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (email.trim() === '') {
      emailError.textContent = 'Email is required.';
      emailError.style.display = 'block';
      isValid = false;
    } else if (!emailPattern.test(email)) {
      emailError.style.display = 'block';
      isValid = false;
    }

    // Validate password
    if (passwordField.value.trim() === '') {
      passwordError.style.display = 'block';
      isValid = false;
    }

    return isValid;
  }
</script>

</body>
</html>
