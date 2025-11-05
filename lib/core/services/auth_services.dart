import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  AuthServices._internal();
  static final AuthServices _instance = AuthServices._internal();
  factory AuthServices() => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    forceCodeForRefreshToken: true,
  );

  /// Logout from Google & Firebase
  Future<void> logout() async {
    try {
      if (!kIsWeb) {
        try {
          await _googleSignIn.disconnect();
        } catch (_) {}
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
    } catch (e) {
      // ignore or log
    }
  }

  /// Google Login
  Future<UserCredential?> loginWithGoogle({bool forceAccountPicker = false}) async {
    try {
      if (forceAccountPicker) {
        await logout();
      }

      if (kIsWeb) {
        final provider = GoogleAuthProvider()
          ..setCustomParameters({'prompt': 'select_account'});
        return await _auth.signInWithPopup(provider);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      return null;
    }
  }

  /// Get Firebase JWT for backend
  Future<String?> getFirebaseIdToken() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      return await user.getIdToken();
    } catch (e) {
      return null;
    }
  }
}
