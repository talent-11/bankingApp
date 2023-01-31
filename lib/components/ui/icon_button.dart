import 'package:flutter/material.dart';

class FotocIconButton extends StatelessWidget {
  const FotocIconButton(
    {
      Key? key,
      this.buttonColor,
      required this.icon,
      required this.onPressed
    }
  ) : super(key: key);
     
  final Function onPressed;
  final Widget icon;
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    Color? mainColor = buttonColor ?? Theme.of(context).primaryColor;

    return TextButton(
      onPressed: () {
        onPressed();
      },
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: icon
        )
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: mainColor)
          )
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return mainColor.withOpacity(0.8);
            }
            return mainColor; // Use the component's default.
          },
        )
      )
    );
  }
}
