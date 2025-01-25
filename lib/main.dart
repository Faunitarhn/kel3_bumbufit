import 'package:flutter/material.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(const BumbuFitApp());
}

class BumbuFitApp extends StatelessWidget {
  const BumbuFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BumbuFit',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SearchScreen(),
    );
  }
}
