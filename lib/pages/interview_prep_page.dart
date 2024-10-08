// interview_prep_page.dart

import 'package:flutter/material.dart';
import 'shared_layout.dart'; // Import the shared layout

class InterviewPrepPage extends StatelessWidget {
  const InterviewPrepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Interview Preparation'),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(
          child: Text(
            'interview_prep_page',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
