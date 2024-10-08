import 'package:flutter/material.dart';
import 'shared_layout.dart'; // Import SharedLayout

class ApplicationTrackerPage extends StatelessWidget {
  const ApplicationTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use SharedLayout to wrap the content
    return SharedLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Application Tracker'),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(
          child: Text(
            'Application track',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
