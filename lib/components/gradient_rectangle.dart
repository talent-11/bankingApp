import 'package:flutter/material.dart';

class GradientRectangle extends StatelessWidget {
  const GradientRectangle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: FractionalOffset.bottomRight,
        end: FractionalOffset.topLeft,
        colors: [
          const Color(0xff2a14f6).withOpacity(0.6),
          const Color(0xffe409f9).withOpacity(0.6)
        ],
      )),
    );
  }
}
