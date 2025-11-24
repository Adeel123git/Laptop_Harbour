import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get user => _auth.authStateChanges();

  // Sign Up
  Future<String?> signUp(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Create user document
      await _db.collection('users').doc(result.user!.uid).set({
        'name': name,
        'email': email,
        'wishlist': [],
        'role': 'user',
        'createdAt': DateTime.now(),
      });
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Sign In
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}