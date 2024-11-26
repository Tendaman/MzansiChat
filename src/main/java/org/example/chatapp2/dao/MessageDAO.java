package org.example.chatapp2.dao;

import org.example.chatapp2.model.Message;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class MessageDAO {

    // Method to save the message to the database
    public static void saveMessage(Message message) {
        String sql = "INSERT INTO messages (sender, receiver, content, timestamp, is_read) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, message.getSender());
            stmt.setString(2, message.getReceiver());
            stmt.setString(3, message.getContent());
            stmt.setTimestamp(4, new Timestamp(new Date().getTime()));
            stmt.setBoolean(5, message.isRead());  // Set is_read to false by default
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Method to retrieve messages between two users
    public static List<Message> getMessages(String sender, String receiver) {
        String sql = "SELECT * FROM messages WHERE (sender = ? AND receiver = ?) OR (sender = ? AND receiver = ?) ORDER BY timestamp ASC";
        List<Message> messages = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sender);
            stmt.setString(2, receiver);
            stmt.setString(3, receiver);
            stmt.setString(4, sender);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Message message = new Message(
                        rs.getString("sender"),
                        rs.getString("receiver"),
                        rs.getString("content"),
                        rs.getTimestamp("timestamp"),
                        rs.getBoolean("is_read")
                );
                messages.add(message);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return messages;
    }

    private static Connection getConnection() throws SQLException {
        String url = "jdbc:mariadb://localhost:3306/chatapp2";
        String user = "root";
        String password = "";

        Connection conn = DriverManager.getConnection(url, user, password);
        if (conn == null) {
            throw new SQLException("Failed to establish a database connection.");
        }
        return conn;
    }

    // Method to retrieve the last message for each conversation
    public static List<Message> getLastMessages(String username) {
        String sql = "SELECT * FROM messages " +
                "WHERE id IN (" +
                "  SELECT MAX(id) FROM messages " +
                "  WHERE sender = ? OR receiver = ? " +
                "  GROUP BY CASE WHEN sender = ? THEN receiver ELSE sender END" +
                ") ORDER BY timestamp DESC";

        List<Message> messages = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, username);
            stmt.setString(3, username);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Message message = new Message(
                        rs.getString("sender"),
                        rs.getString("receiver"),
                        rs.getString("content"),
                        rs.getTimestamp("timestamp"),
                        rs.getBoolean("is_read")
                );
                messages.add(message);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return messages;
    }

    // Method to count unread messages for a user
    public static int countUnreadMessages(String receiver) {
        String sql = "SELECT COUNT(*) FROM messages WHERE receiver = ? AND sender = ? AND is_read = FALSE";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, receiver);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Method to mark all messages between two users as read
    public static void markMessagesAsRead(String sender, String receiver) {
        String sql = "UPDATE messages SET is_read = TRUE WHERE sender = ? AND receiver = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sender);
            stmt.setString(2, receiver);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
