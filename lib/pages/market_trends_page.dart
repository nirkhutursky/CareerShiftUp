import 'package:flutter/material.dart';
import 'shared_layout.dart'; // Import the shared layout

class MarketTrendsPage extends StatelessWidget {
  const MarketTrendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Market Trends'),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(
          child: Text(
            'Market Trends Page',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
