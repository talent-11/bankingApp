import 'package:flutter/material.dart';
import 'package:fotoc/components/wizard/text_with_cc.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog(
    {
      Key? key,
      required this.text,
      this.title
    }
  ) : super(key: key);
  
  final String text;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? "Error"),
      content: TextWithCC(text: text, color: Colors.black87, fontSize: 14,),
    );
  }
}
