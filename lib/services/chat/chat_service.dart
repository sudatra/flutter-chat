import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/message.dart';
import 'package:flutter_chat/services/auth/auth_service.dart';

class ChatService extends ChangeNotifier {
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

  // get all users except blocked user as stream
  Stream<List<Map<String, dynamic>>> getUnblockedUsersStream() {
    final currentUser = _authService.getCurrentUser();

    return _firestore
      .collection("Users")
      .doc(currentUser!.uid)
      .collection("BlockedUsers")
      .snapshots()
      .asyncMap((snapshot) async {
        final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
        final usersSnapshot = await _firestore.collection("Users").get();

        return usersSnapshot.docs.where((doc) => 
          doc.data()["email"] != currentUser.email && 
          !blockedUserIds.contains(doc.id)
          ).map((doc) => doc.data()).toList();
      })
    ;
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

  // report user
  Future<void> reportUser(String messageId, String userId) async {
    final currentUser = _authService.getCurrentUser();
    final report = {
      'reportedBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp()
    };

    await _firestore.collection("reports").add(report);
  }

  // block user
  Future<void> blockUser(String userId) async {
    final currentUser = _authService.getCurrentUser();
    await _firestore
      .collection("Users")
      .doc(currentUser!.uid)
      .collection("BlockedUsers")
      .doc(userId)
      .set({})
    ;

    notifyListeners();
  }

  // unblock user
  Future<void> unblockUser(String userId) async {
    final currentUser = _authService.getCurrentUser();
    await _firestore
      .collection("Users")
      .doc(currentUser!.uid)
      .collection("BlockedUsers")
      .doc(userId)
      .delete()
    ;

    notifyListeners();
  } 

  // get blocked user stream
  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userId) {
    return _firestore
      .collection("Users")
      .doc(userId)
      .collection("BlockedUsers")
      .snapshots()
      .asyncMap((snapshot) async {
        final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
        final userDocs = await Future.wait(
          blockedUserIds.map((id) => _firestore.collection("Users").doc(id).get())
        );

        return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
  }
}