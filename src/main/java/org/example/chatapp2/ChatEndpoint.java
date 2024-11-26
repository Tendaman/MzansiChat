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

@ServerEndpoint("/chat")
public class ChatEndpoint {

    private static final Set<Session> sessions = Collections.synchronizedSet(new HashSet<>());

    @OnOpen
    public void onOpen(Session session) {
        sessions.add(session);
    }

    @OnMessage
    public void onMessage(String messageJson, Session session) throws IOException {
        // Parse the incoming message from JSON
        Gson gson = new Gson();
        Message message = gson.fromJson(messageJson, Message.class);

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
    }

    @OnClose
    public void onClose(Session session) {
        sessions.remove(session);
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        // Log or handle the error
        throwable.printStackTrace();
    }
}
