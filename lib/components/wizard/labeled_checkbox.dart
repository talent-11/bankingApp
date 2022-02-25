import 'package:flutter/material.dart';

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox(
      {Key? key,
      required this.labelText,
      required this.checked,
      required this.valueChanged})
      : super(key: key);

  final String labelText;
  final bool checked;
  final Function valueChanged;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      // const Set<MaterialState> interactiveStates = <MaterialState>{
      //   MaterialState.pressed,
      //   MaterialState.hovered,
      //   MaterialState.focused,
      //   MaterialState.selected,
      // };
      // if (states.any(interactiveStates.contains)) {
      //   return const Color(0xffe8ecef);
      // }
      return const Color(0xffe8ecef);
    }

    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Checkbox(
          fillColor: MaterialStateProperty.resolveWith(getColor),
          checkColor: Theme.of(context).primaryColor,
          value: checked,
          onChanged: (bool? value) {
            valueChanged(value);
          }),
      Expanded(
          child: Text(labelText,
              style:
                  const TextStyle(fontSize: 14.0, color: Color(0xff778ca2)))),
    ]);
  }
}
