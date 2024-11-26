package org.example.chatapp2.model;

import java.util.Date;

public class Message {
    private String sender;
    private String receiver;
    private String content;
    private Date timestamp;
    private boolean isRead;

    public Message(String sender, String receiver, String content, Date timestamp, boolean isRead) {
        this.sender = sender;
        this.receiver = receiver;
        this.content = content;
        this.timestamp = timestamp;
        this.isRead = isRead;
    }

    public String getSender() {
        return sender;
    }

    public String getReceiver() {
        return receiver;
    }

    public String getContent() {
        return content;
    }

    public Date getTimestamp() {
        return timestamp;
    }
    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }
}
