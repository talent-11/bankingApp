import 'package:flutter/material.dart';
import 'package:fotoc/components/wizard/text_spans.dart';

class TextWithCC extends StatelessWidget {
  const TextWithCC(
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
    return RichText(
      text: TextSpan(
        children: decorateArticle(context, text, fontSize: fontSize, fontWeight: fontWeight, color: color, lineHeight: lineHeight)
      )
    );
  }
}
