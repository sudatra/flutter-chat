import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // get firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // login
  Future<UserCredential> signInWithEmailAndPassord(
    String email,
    String password
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch(e) {
      throw Exception(e.code);
    }
  }

  // sign up
  Future<UserCredential> signUpWithEmailAndPassord(
    String email,
    String password
  ) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch(e) {
      throw Exception(e.code);
    }
  }

  // sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}