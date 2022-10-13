import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog(
    {
      Key? key,
      required this.text,
    }
  ) : super(key: key);
     
  final String text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: Text(text),
    );
  }
}
