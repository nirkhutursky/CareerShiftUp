import 'package:flutter/material.dart';
import 'package:job_seeker/pages/shared_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      child: Center(
        child: Text(
          'Welcome to the Home Page!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
