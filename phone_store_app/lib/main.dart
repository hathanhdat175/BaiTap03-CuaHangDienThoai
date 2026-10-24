import 'package:flutter/material.dart';
import 'screens/intro_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cửa hàng điện thoại',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFFFC107),
        useMaterial3: true,
      ),
      home: const IntroScreen(),
    );
  }
}
