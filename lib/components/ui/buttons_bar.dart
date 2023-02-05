import 'package:flutter/material.dart';
import 'package:fotoc/components/wizard/button.dart';

class ButtonsBar extends StatelessWidget {
  const ButtonsBar(
    {
      Key? key,
      required this.height,
      this.space,
      required this.widths,
      required this.labels,
      this.outlines,
      required this.functions
    }
  ) : super(key: key);
  
  final double height;
  final double? space;
  final List<double> widths;
  final List<String> labels;
  final List<bool>? outlines;
  final List<Function> functions;

  List<Widget> decorateButtons(BuildContext context) {
    List<Widget> widgets = [];

    for (int i = 0; i < labels.length; i ++) {
      if (i > 0) {
        widgets.add(SizedBox(width: space ?? 20));
      }

      widgets.add(
        SizedBox(
          width: widths[i],
          height: height,
          child: FotocButton(
            outline: outlines != null ? outlines![i] : false,
            buttonText: labels[i],
            onPressed: functions[i],
          ),
        )
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: decorateButtons(context)
    );
  }
}
