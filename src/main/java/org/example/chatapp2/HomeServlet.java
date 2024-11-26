package org.example.chatapp2;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import org.example.chatapp2.dao.MessageDAO;

import java.io.IOException;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            String username = (String) session.getAttribute("user");

            // Retrieve the number of unread messages for the logged-in user
            int unreadMessagesCount = MessageDAO.countUnreadMessages(username);
            request.setAttribute("unreadMessagesCount", unreadMessagesCount);

            request.getRequestDispatcher("home.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}
