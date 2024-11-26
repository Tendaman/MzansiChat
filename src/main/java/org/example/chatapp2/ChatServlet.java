package org.example.chatapp2;

import org.example.chatapp2.dao.MessageDAO;
import org.example.chatapp2.model.Message;
import org.example.chatapp2.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/chat")
public class ChatServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User loggedInUser = (User) session.getAttribute("user");
            String receiver = request.getParameter("username");

            if (receiver == null || receiver.trim().isEmpty()) {
                response.sendRedirect("contacts.jsp");
                return;
            }

            // Mark messages as read
            MessageDAO.markMessagesAsRead(receiver, loggedInUser.username());

            List<Message> messages = MessageDAO.getMessages(loggedInUser.username(), receiver);

            request.setAttribute("receiver", receiver);
            request.setAttribute("messages", messages);
            request.getRequestDispatcher("chat.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedInUser = (User) session.getAttribute("user");

        if (loggedInUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String receiver = request.getParameter("receiver");
        String content = request.getParameter("content");

        if (receiver == null || content == null || receiver.trim().isEmpty() || content.trim().isEmpty()) {
            response.sendRedirect("chat.jsp?username=" + receiver);
            return;
        }

        Message message = new Message(
                loggedInUser.username(),
                receiver,
                content,
                new Timestamp(System.currentTimeMillis()), // Use current timestamp
                false
        );

        MessageDAO.saveMessage(message);

        response.sendRedirect("chat?username=" + receiver);
    }
}
