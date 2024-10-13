import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job_seeker/pages/shared_layout.dart';
import 'package:job_seeker/pages/api_service.dart';
import 'package:job_seeker/pages/resume_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadResumeData();
  }

  Future<void> _loadResumeData() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final idToken = await user.getIdToken();

      if (idToken == null) {
        throw Exception('Failed to retrieve ID token.');
      }

      print("ID Token Retrieved: $idToken");

      // Fetch the existing resume for the user
      final resumes = await ApiService.getResumes(idToken);
      if (resumes.isNotEmpty) {
        // Assume there is only one resume per user and get the first one
        final resumeData = resumes[0];

        // Set the resume data to the provider
        final resumeProvider =
            Provider.of<ResumeProvider>(context, listen: false);
        resumeProvider.setResumeData(resumeData);
      } else {
        print('No existing resume found for the user.');
      }
    } catch (e) {
      print('Error fetching resume: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Home Page!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
