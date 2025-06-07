import 'package:flutter/material.dart';
import 'package:flutter_chat/components/user_tile.dart';
import 'package:flutter_chat/services/auth/auth_service.dart';
import 'package:flutter_chat/services/chat/chat_service.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Unblock User"),
        content: const Text("Are you sure want to unblock this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel")
          ),

          TextButton(
            onPressed: () {
              ChatService().unblockUser(userId);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User Unblocked"))
              );
            },
            child: Text("Unblock")
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = _authService.getCurrentUser()!.uid;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Center(
          child: Text("Blocked Users", textAlign: TextAlign.center)
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _chatService.getBlockedUsersStream(userId), 
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return const Center(
              child: Text("Error...")
            );
          }

          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator()
            );
          }

          final blockedUsers = snapshot.data ?? [];
          if(blockedUsers.isEmpty) {
            return const Center(
              child: Text("No Blocked Users")
            ); 
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              final user = blockedUsers[index];
              return UserTile(
                text: user["email"],
                onTap: () => _showUnblockBox(context, user["uid"]),
              );
            }
          );
        }
      ),
    );
  }
}