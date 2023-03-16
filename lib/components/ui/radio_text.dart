import 'package:flutter/material.dart';

class RadioText extends StatelessWidget {
  RadioText(
    {
      Key? key,
      required this.label,
      required this.groupValue,
      this.disabled,
      this.textColor,
      required this.onChanged,
    }
  ) : super(key: key);
  
  final String label;
  final String groupValue;
  bool? disabled;
  Color? textColor;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<String>(
          activeColor: Theme.of(context).primaryColor,
          value: label,
          groupValue: groupValue,
          onChanged: disabled == true ? null : (value) => onChanged(value),
        ),
        Text(
          label,
          style: TextStyle(color: textColor ?? const Color(0xff98a9bc), fontSize: 14),
        )
      ],
    );
  }
}
