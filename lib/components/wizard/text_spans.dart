import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

final fotocSpans = <String, Function?>{
  'c': (BuildContext context, {required String text, double? fontSize, Color? color, double? lineHeight}) 
    => clickableTextSpan(context, text: text, fontSize: fontSize, color: color, lineHeight: lineHeight),
  'u': (BuildContext context, {required String text, double? fontSize, Color? color, double? lineHeight}) 
    => underlinedTextSpan(context, text: text, fontSize: fontSize, color: color, lineHeight: lineHeight),
  's': (BuildContext context, {required double fontSize, Color? color}) 
    => symbolSpan(height: fontSize * 1.286, color: color),
  'z': (BuildContext context, {required String text, double? fontSize, Color? color, double? lineHeight}) 
    => defaultTextSpan(context, text: text, fontSize: fontSize, color: color, lineHeight: lineHeight),
};

TextSpan defaultTextSpan(BuildContext context, {required String text, double? fontSize, Color? color, double? lineHeight}) => TextSpan(
  text: text,
  style: TextStyle(
    fontSize: fontSize ?? 14.0, 
    color: color ?? const Color(0xff98a9bc), 
    height: lineHeight ?? 1.4,
    fontWeight: FontWeight.w400,
  ),
);

TextSpan clickableTextSpan(BuildContext context, {required String text, double? fontSize, Color? color, double? lineHeight}) => TextSpan(
  recognizer: TapGestureRecognizer()..onTap = () => {},
  style: TextStyle(
    fontSize: fontSize ?? 14.0, 
    color: color ?? const Color(0xff252631), 
    height: lineHeight ?? 1.4,
    fontWeight: FontWeight.w500,
  ),
  children: [
    TextSpan(text: text, style: const TextStyle(decoration: TextDecoration.underline))
  ]
);

TextSpan underlinedTextSpan(BuildContext context, {required String text, double? fontSize, Color? color, double? lineHeight}) => TextSpan(
  style: TextStyle(
    fontSize: fontSize ?? 14.0, 
    color: color ?? const Color(0xff98a9bc), 
    height: lineHeight ?? 1.4,
    fontWeight: FontWeight.w400,
  ),
  children: [
    TextSpan(text: text, style: const TextStyle(decoration: TextDecoration.underline))
  ]
);

WidgetSpan symbolSpan({required double height, Color? color}) => WidgetSpan(
  child: SvgPicture.asset(
    "assets/svgs/cc.svg",
    width: height * 0.379412,
    height: height,
    color: color ?? const Color(0xff98a9bc),
  )
);
    
List<InlineSpan> decorateArticle(BuildContext context, String article, {double? fontSize, Color? color, double? lineHeight}) {
  var children = <InlineSpan>[];
  
  article.split('{{').forEach((element) {
    if (element.contains('}}')) {
      final key = element.split('}}')[0].substring(0, 1);
      final mainText = element.split('}}')[0].substring(1);

      InlineSpan widget;
      if (key == 's') {
        widget = fotocSpans['s']!(context, fontSize: (fontSize ?? 14.0), color: color);
      } else {
        widget = fotocSpans[key]!(context, text: mainText, fontSize: fontSize, color: color, lineHeight: lineHeight);
      }

      children.add(widget);

      if (!element.endsWith('}}')) {
        children.add(fotocSpans['z']!(context, text: element.split('}}')[1], fontSize: fontSize, color: color, lineHeight: lineHeight));
      }
    } else {
      children.add(fotocSpans['z']!(context, text: element, fontSize: fontSize, color: color, lineHeight: lineHeight));
    }
  });

  return children;
}

// Paint textBorderPaint = Paint()
//   ..color = Colors.green
//   ..style = PaintingStyle.stroke
//   ..strokeCap = StrokeCap.round
//   ..strokeWidth = 2.0;