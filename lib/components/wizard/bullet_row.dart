import 'package:flutter/material.dart';
import 'package:fotoc/components/wizard/text_with_cc.dart';

class BulletRow extends StatelessWidget {
  const BulletRow(
    {
      Key? key,
      required this.text,
      this.fontSize,
      this.color,
      this.lineHeight,
    }
  ) : super(key: key);
     
  final String text;
  final double? fontSize;
  final Color? color;
  final double? lineHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.5),
          child: Text(
            "•  ", 
            style: TextStyle(
              color: color ?? const Color(0xff98a9bc),
              fontSize: fontSize ?? 14.0,
              fontWeight: FontWeight.w500,
            )
          ),
        ),
        Expanded(
          child: TextWithCC(text: text, fontSize: fontSize, color: color, lineHeight: lineHeight)
        )
      ],
    );
  }
}
