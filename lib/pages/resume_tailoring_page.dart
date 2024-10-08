import 'package:flutter/material.dart';
import 'shared_layout.dart'; // Import the shared layout

class ResumeTailoringPage extends StatelessWidget {
  const ResumeTailoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Resume Tailoring with AI'),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(
          child: Text(
            'Resume Tailoring with AI Page',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
