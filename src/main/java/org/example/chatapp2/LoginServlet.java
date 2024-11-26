package org.example.chatapp2;

import org.example.chatapp2.dao.UserDAO;
import org.example.chatapp2.util.PasswordUtil;
import org.example.chatapp2.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Retrieve user from database
        User user = UserDAO.getUserByUsername(username);

        if (user == null) {
            // User does not exist
            request.setAttribute("errorMessage", "User does not exist");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp?error=true");
            dispatcher.forward(request, response);
        } else {
            // Check if the provided password matches the stored hashed password
            boolean isPasswordCorrect = PasswordUtil.checkPassword(password, user.password());
            if (isPasswordCorrect) {
                HttpSession session = request.getSession(false);
                session.setAttribute("user", user);
                response.sendRedirect("home.jsp");
            } else {
                // Incorrect password
                request.setAttribute("errorMessage", "Password invalid.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp?error=true");
                dispatcher.forward(request, response);
            }
        }
    }
}
