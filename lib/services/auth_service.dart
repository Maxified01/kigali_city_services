import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Auth state change stream
  Stream<User?> get user => _auth.authStateChanges();

  // Sign up with email & password
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Send email verification
      await result.user!.sendEmailVerification();

      // Create user profile in Firestore
      await _firestore.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return result;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Check if current user's email is verified
  bool get isEmailVerified {
    final user = _auth.currentUser;
    return user != null && user.emailVerified;
  }

  // Reload user to refresh email verification status
  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  // Handle Firebase Auth exceptions (simplified)
  String _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      return e.message ?? 'Authentication error';
    }
    return 'An unexpected error occurred';
  }
}