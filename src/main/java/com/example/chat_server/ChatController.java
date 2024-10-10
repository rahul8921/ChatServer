package com.example.chat_server;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller
public class ChatController {

    @MessageMapping("/send") // The destination for incoming messages
    @SendTo("/topic/messages") // The destination to send messages to
    public String sendMessage(String message) throws Exception {
        // You can add some processing logic here if needed
        return message; // Echo the message back
    }
}
