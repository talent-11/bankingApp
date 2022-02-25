import 'package:flutter/material.dart';

class WizardFooter extends StatelessWidget {
  const WizardFooter(
      {Key? key,
      required this.description,
      required this.buttonText,
      required this.onPressed})
      : super(key: key);

  final String description;
  final String buttonText;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return SizedBox(
      height: 40.0,
      width: deviceSize.width,
      child: Container(
          color: const Color(0xfff8fafb),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(description, style: Theme.of(context).textTheme.bodyText1),
            TextButton(
              onPressed: () {
                onPressed();
              },
              child: Text(buttonText,
                  style: Theme.of(context).textTheme.headline6),
            ),
          ])),
    );
  }
}
