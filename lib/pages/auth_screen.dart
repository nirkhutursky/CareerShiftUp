import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web Google sign-in
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        await _auth.signInWithPopup(googleProvider);
      } else {
        // Mobile Google sign-in
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          // User canceled the sign-in
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);
      }

      print("User signed in: ${_auth.currentUser?.displayName}");
    } catch (e) {
      print("Error signing in with Google: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: ElevatedButton(
          onPressed: _signInWithGoogle,
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
