import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

TextSpan defaultTextSpan(BuildContext context, String text) => TextSpan(
  text: text,
  style: Theme.of(context).textTheme.bodyText1,
);

TextSpan clickableTextSpan(BuildContext context, String text) => TextSpan(
  recognizer: TapGestureRecognizer()..onTap = () => {},
  style: Theme.of(context).textTheme.headline6,
  children: [
    TextSpan(text: text, style: const TextStyle(decoration: TextDecoration.underline))
  ]
);

TextSpan underlinedTextSpan(BuildContext context, String text) => TextSpan(
  style: Theme.of(context).textTheme.bodyText1,
  children: [
    TextSpan(text: text, style: const TextStyle(decoration: TextDecoration.underline))
  ]
);

WidgetSpan symbolSpan(double height) => WidgetSpan(
  child: SvgPicture.asset(
    "assets/svgs/cc.svg",
    width: height * 0.379412,
    height: height,
    color: const Color(0xff98a9bc),
  )
);

// Paint textBorderPaint = Paint()
//   ..color = Colors.green
//   ..style = PaintingStyle.stroke
//   ..strokeCap = StrokeCap.round
//   ..strokeWidth = 2.0;