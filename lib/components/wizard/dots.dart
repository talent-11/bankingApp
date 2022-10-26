import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class Dots extends StatelessWidget {
  const Dots({Key? key, required this.selectedIndex, this.dots = 3}) : super(key: key);

  final double selectedIndex;
  final int dots;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      child: DotsIndicator(
          dotsCount: dots,
          position: selectedIndex,
          decorator: DotsDecorator(
              activeColor: Theme.of(context).primaryColor,
              color: const Color(0xffcbd4dd))),
    );
  }
}
