import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class FotocText extends StatelessWidget {
  const FotocText({Key? key, required this.selectedIndex}) : super(key: key);

  final double selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      child: DotsIndicator(
          dotsCount: 3,
          position: selectedIndex,
          decorator: DotsDecorator(
              activeColor: Theme.of(context).primaryColor,
              color: const Color(0xffcbd4dd))),
    );
  }
}
