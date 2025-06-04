import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/models/message.dart';
import 'package:flutter_chat/services/auth/auth_service.dart';

class ChatService {
  // get firestore and firebase-auth instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();


  // get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverId, message) async {
    final String currentUserId = _authService.getCurrentUser()!.uid;
    final String currentUserEmail = _authService.getCurrentUser()!.email!;
    final Timestamp currentTimestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: currentTimestamp
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
      .collection("chat_rooms")
      .doc(chatRoomId)
      .collection("messages")
      .add(newMessage.toMap())
    ;
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userId, otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
      .collection("chat_rooms")
      .doc(chatRoomId)
      .collection("messages")
      .orderBy("timestamp", descending: false)
      .snapshots()
    ;
  }
}