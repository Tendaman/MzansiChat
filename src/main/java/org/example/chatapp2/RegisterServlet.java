package org.example.chatapp2;

import org.example.chatapp2.dao.UserDAO;
import org.example.chatapp2.util.PasswordUtil;

import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;

import org.example.chatapp2.model.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Hash password
        String hashedPassword = PasswordUtil.hashPassword(password);

        // Save user in database
        User user = new User(name, username, email, hashedPassword);
        UserDAO.saveUser(user);

        // Redirect to login page
        response.sendRedirect("login.jsp");
    }
}
