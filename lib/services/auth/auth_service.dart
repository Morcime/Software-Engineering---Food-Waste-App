import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<String?> getUserRole() async {
    final user = _firebaseAuth.currentUser;
    if(user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if(!doc.exists) return null;

    return doc.data()? ['role'] as String?;
  }
  Future<UserCredential> signInWithEmailandPassword(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed.');
    }
  }

  Future<UserCredential> signUpWithEmailPassword(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('This email is already registered. Please log in instead.');
      } else if (e.code == 'weak-password') {
        throw Exception('The password is too weak.');
      } else {
        throw Exception('Registration failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
