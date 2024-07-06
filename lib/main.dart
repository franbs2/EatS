import 'package:eats/presentation/view/initial_page.dart';
import 'package:flutter/material.dart';

import 'presentation/view/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: InitialPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
