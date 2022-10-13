import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {Key? key, required this.buttonText, this.loading, required this.onPressed})
      : super(key: key);

  final String buttonText;
  final bool? loading;
  final Function onPressed;

  List<Widget> children(BuildContext context) {
    var widget = <Widget>[];

    if (loading != null && loading == true) {
      widget.add(const CircularProgressIndicator(color: Colors.white, strokeWidth: 3));
      widget.add(const SizedBox(width: 8));
    }

    widget.add(Text(buttonText, style: Theme.of(context).textTheme.headline4));

    return widget;
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return TextButton(
      onPressed: () {
        onPressed();
      },
      child: SizedBox(
        width: deviceSize.width - 48.0,
        height: 46.0,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children(context),
          )
        )
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(46.0))
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Theme.of(context).primaryColor.withOpacity(0.9);
            }
            return Theme.of(context)
                .primaryColor; // Use the component's default.
          },
        )
      )
    );
  }
}
