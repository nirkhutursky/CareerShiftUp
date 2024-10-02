import 'package:flutter/material.dart';

class ApplicationTrackerPage extends StatelessWidget {
  const ApplicationTrackerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder for the Resume Tailoring with AI page
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application track'),
        backgroundColor: Colors.blueAccent,
      ),
      body: const Center(
        child: Text(
          'Application track',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
