import 'package:flutter/material.dart';
import 'shared_layout.dart'; // Import the shared layout

class SkillBasedResumesPage extends StatelessWidget {
  const SkillBasedResumesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Skill Based Resume'),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(
          child: Text(
            'Skill Based Resume',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
