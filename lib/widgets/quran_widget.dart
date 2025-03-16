import 'package:flutter/material.dart';

class QuranWidget extends StatelessWidget {
  const QuranWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with title "Tasks"
      // Body with the same background image used in other screens
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.network(
              "images/pexels-a-darmel-8164743.jpg",
              fit: BoxFit.cover,
            ),
          ),
          // You can add additional content here if needed
          Center(
            child: Text(
              "Tasks Page",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
