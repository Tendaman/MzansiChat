package org.example.chatapp2;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import org.example.chatapp2.dao.MessageDAO;
import org.example.chatapp2.model.Message;
import com.google.gson.Gson;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

@ServerEndpoint("/chat")
public class ChatEndpoint {

    private static final Set<Session> sessions = Collections.synchronizedSet(new HashSet<>());
    private static final Logger logger = Logger.getLogger(ChatEndpoint.class.getName());

    @OnOpen
    public void onOpen(Session session) {
        sessions.add(session);
        logger.info("New connection: " + session.getId());
    }

    @OnMessage
    public void onMessage(String messageJson, Session session) throws IOException {
        try {
            // Parse the incoming message from JSON
            Gson gson = new Gson();
            Message message = gson.fromJson(messageJson, Message.class);

            // Optional: Validate message content (e.g., non-empty message content)
            if (message.getSender() == null || message.getReceiver() == null || message.getContent().isEmpty()) {
                session.getBasicRemote().sendText("{\"error\": \"Invalid message content.\"}");
                return;
            }

            // Save the message to the database
            MessageDAO.saveMessage(message);

            // Broadcast the message to all connected sessions except the sender
            synchronized (sessions) {
                for (Session s : sessions) {
                    if (s.isOpen() && !s.equals(session)) {
                        s.getBasicRemote().sendText(messageJson);
                    }
                }
            }
        } catch (Exception e) {
            // Log the error and notify the client if the message was invalid
            logger.log(Level.SEVERE, "Error processing message: " + messageJson, e);
            session.getBasicRemote().sendText("{\"error\": \"Error processing message.\"}");
        }
    }

    @OnClose
    public void onClose(Session session) {
        sessions.remove(session);
        logger.info("Connection closed: " + session.getId());
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        // Log or handle the error
        logger.log(Level.SEVERE, "Error with session " + session.getId(), throwable);
    }
}
