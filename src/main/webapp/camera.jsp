<%@ page import="org.example.chatapp2.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Camera</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            padding: 0;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            overflow: hidden;
        }
        .camera-container {
            position: relative;
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            background: black;
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
        video {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .controls {
            position: absolute;
            bottom: 20px;
            display: flex;
            justify-content: center;
            width: 100%;
        }
        .camera-btn, .capture-btn, .submit-btn, .back-button {
            background: #00b4d8;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin: 0 10px;
        }
        .camera-btn:hover, .capture-btn:hover, .submit-btn:hover, .back-button:hover {
            background: #0096c7;
        }
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
<div class="camera-container">
    <video id="video" autoplay></video>
    <div class="controls">
        <button id="captureBtn" class="capture-btn">Capture</button>
        <form id="captureForm" action="camera" method="post" enctype="multipart/form-data" class="hidden">
            <input type="hidden" name="receiver" value="<%= request.getParameter("receiver") %>" />
            <input type="hidden" id="imageData" name="imageData" />
            <button type="submit" id="submitBtn" class="submit-btn hidden">Send Image</button>
        </form>
        <a href="chat.jsp?username=<%= request.getParameter("receiver") %>" class="back-to-home">Back to Chat</a>
    </div>
</div>
<script>
    const video = document.getElementById('video');
    const captureBtn = document.getElementById('captureBtn');
    const captureForm = document.getElementById('captureForm');
    const imageDataInput = document.getElementById('imageData');
    const submitBtn = document.getElementById('submitBtn');

    // Access the device camera and stream to the video element
    navigator.mediaDevices.getUserMedia({ video: true })
        .then(stream => {
            video.srcObject = stream;
        })
        .catch(err => {
            console.error("Error accessing the camera: ", err);
        });

    // Capture the image and prepare it for submission
    captureBtn.addEventListener('click', () => {
        const canvas = document.createElement('canvas');
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        const context = canvas.getContext('2d');
        context.drawImage(video, 0, 0, canvas.width, canvas.height);
        const imageData = canvas.toDataURL('image/png');
        imageDataInput.value = imageData;
        submitBtn.classList.remove('hidden');
        captureForm.classList.remove('hidden');
        captureBtn.classList.add('hidden');
    });
</script>
</body>
</html>
