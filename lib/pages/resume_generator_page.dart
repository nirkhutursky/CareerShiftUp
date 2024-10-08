import 'package:flutter/material.dart';
import 'shared_layout.dart'; // Import the shared layout

class ResumeGeneratorPage extends StatelessWidget {
  const ResumeGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Resume Generator'),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(
          child: Text(
            'Resume Generator',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
