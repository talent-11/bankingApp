import 'package:flutter/material.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/components/wizard/text_with_cc.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog(
    {
      Key? key,
      required this.text,
      this.title,
      required this.onPressedYes,
      required this.onPressedNo,
    }
  ) : super(key: key);
  
  final String text;
  final String? title;
  final Function onPressedYes;
  final Function onPressedNo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? "Confirm"),
      content: TextWithCC(text: text, color: Colors.black87, fontSize: 14),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(width: 80, height: 32, child: FotocButton(outline: true, buttonText: "No", onPressed: onPressedNo)),
        SizedBox(width: 80, height: 32, child: FotocButton(buttonText: "Yes", onPressed: onPressedYes)),
      ],
    );
  }
}
