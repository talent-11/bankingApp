import 'package:flutter/material.dart';

class RadioText extends StatelessWidget {
  const RadioText(
    {
      Key? key,
      required this.label,
      required this.groupValue,
      required this.onChanged,
    }
  ) : super(key: key);
  
  final String label;
  final String groupValue;
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
          onChanged: (value) => onChanged(value),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyText1,
        )
      ],
    );
  }
}
