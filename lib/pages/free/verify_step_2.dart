import 'package:flutter/material.dart';

class AppState {
  bool loading;
  String imagePath;
  bool captured;

  AppState(this.loading, this.imagePath, this.captured);
}

class VerifyStep2Page extends StatefulWidget {
  const VerifyStep2Page({Key? key}) : super(key: key);

  @override
  State<VerifyStep2Page> createState() => _VerifyStep2PageState();
}

class _VerifyStep2PageState extends State<VerifyStep2Page> {
  void onPressedUpload(BuildContext context) {
    Navigator.pushNamed(context, '/free/verify/3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          
        ],
      )
    );
  }
}
