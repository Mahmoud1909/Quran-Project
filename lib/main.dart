import 'package:flutter/material.dart';
import 'package:quran_project/screens/HomeScreen.dart';
import 'package:quran_project/screens/LoginScreen.dart';
import 'package:quran_project/widgets/prayer_times_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 's0',
      routes: {
        's0': (context) => LoginScreen(),
        's1': (context) => HomeScreen(),  // هنا يجب أن يكون HomeScreen يحتوي على bottomNavigationBar
      },
    );
  }
}
