import 'package:flutter/material.dart';
import 'package:fotoc/components/wizard/text_with_cc.dart';

class EmphaticRow extends StatelessWidget {
  const EmphaticRow(
    {
      Key? key,
      required this.text,
      this.fontSize,
      this.fontWeight,
      this.color,
      this.lineHeight,
    }
  ) : super(key: key);
     
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final double? lineHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10), 
      child: Expanded(
        child: TextWithCC(text: text, fontSize: fontSize, fontWeight: fontWeight, color: color, lineHeight: lineHeight)
      )
    );
  }
}
