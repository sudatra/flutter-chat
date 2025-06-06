import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/components/chat_bubble.dart';
import 'package:flutter_chat/components/text_field.dart';
import 'package:flutter_chat/services/auth/auth_service.dart';
import 'package:flutter_chat/services/chat/chat_service.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverId;
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverId
  });

  void sendMessage() async {
    if(_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(receiverId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Center(
          child: Text(receiverEmail, textAlign: TextAlign.center)
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),

          _buildUserInput()
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _authService.getCurrentUser()!.uid;

    return StreamBuilder(
      stream: _chatService.getMessages(receiverId, senderId),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return const Text("Error");
        }

        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = (data['senderId'] == _authService.getCurrentUser()!.uid);
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
          )
        ],
      )
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(child: CustomTextField(
            controller: _messageController,
            hintText: 'Type a Message',
            obscureText: false,
          )),

          Container(
            margin: EdgeInsets.only(right: 25.0),
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle
            ),
            child: IconButton(onPressed: sendMessage, icon: Icon(Icons.arrow_upward, color: Colors.white))
          )
        ]
      ),
    );
  }
}