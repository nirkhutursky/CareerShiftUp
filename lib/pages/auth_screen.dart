import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(); // Keep it simple with no scopes
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore reference

  Future<void> _signInWithGoogle() async {
    try {
      // Trigger the Google Authentication process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        return;
      }

      // Get the authentication details from Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential using Google Authentication
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase using the Google credential
      await _auth.signInWithCredential(credential);

      // Successfully signed in
      print("User signed in: ${_auth.currentUser?.displayName}");

      // Add data to Firestore after login
      await _addDataToFirestore();
    } catch (e) {
      // Handle sign-in error
      print("Error signing in with Google: $e");
    }
  }

  Future<void> _addDataToFirestore() async {
    try {
      // Create a reference to a test collection
      final docRef =
          _firestore.collection('testData').doc(_auth.currentUser?.uid);

      // Set some data in Firestore
      await docRef.set({
        'name': _auth.currentUser?.displayName ?? 'Unknown',
        'email': _auth.currentUser?.email ?? 'No Email Provided',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Retrieve the data back from Firestore
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        print("Data retrieved from Firestore: ${snapshot.data()}");
      } else {
        print("No data found for the document");
      }
    } catch (e) {
      print("Error handling Firestore: $e");
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
