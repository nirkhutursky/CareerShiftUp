import 'package:flutter/material.dart';
import 'shared_layout.dart'; // Import the shared layout

class PortfolioBuilderPage extends StatelessWidget {
  const PortfolioBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Portfolio'),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(
          child: Text(
            'Portfolio',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
