package org.example.chatapp2;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import jakarta.servlet.http.HttpSession;
import org.example.chatapp2.dao.UserDAO;
import org.example.chatapp2.model.User;

@WebServlet("/contacts")
public class ContactsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("username") != null) {
            // Correctly calling the static method without an instance
            List<User> users = UserDAO.getAllUsers();

            request.setAttribute("users", users);
            request.getRequestDispatcher("/contacts.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }

    }
}
