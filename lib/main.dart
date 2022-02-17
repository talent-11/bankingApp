import 'package:flutter/material.dart';

import 'pages/wizard/login_with_finger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FOTOC',
      theme: ThemeData(
        primaryColor: const Color(0xff5d10f6),
        primarySwatch: Colors.blue,
      ),
      home: const LoginWithFingerPage(),
    );
  }
}
