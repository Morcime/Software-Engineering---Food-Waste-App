import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  //get instance of firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // get current user
  User? getCurrentUser(){
    return _firebaseAuth.currentUser;
  }

  // sign in
  Future<UserCredential> signInWithEmailandPassword(String email, password) async {
    try{
      // sign user in
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );


      return userCredential;
    }

    // catch error
    on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }

  // sign up
  Future<UserCredential> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Berhasil, return UserCredential
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Map error code ke pesan
      String message;
      if (e.code == 'email-already-in-use') {
        message = 'This email is already registered. Please log in instead.';
      } else if (e.code == 'weak-password') {
        message = 'The password is too weak.';
      } else {
        message = 'Registration failed: ${e.message}';
      }
      throw Exception(message); // throw dengan pesan error custom
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  //sign out
  Future<void> signOut() async{
    return await _firebaseAuth.signOut();
  }
}