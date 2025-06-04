import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;

  const ChatPage({
    super.key,
    required this.receiverEmail
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(receiverEmail, textAlign: TextAlign.center)
        ),
        backgroundColor: Theme.of(context).colorScheme.primary
      ),
    );
  }
}