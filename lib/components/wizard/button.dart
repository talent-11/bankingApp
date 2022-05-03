import 'package:flutter/material.dart';

class FotocButton extends StatelessWidget {
  const FotocButton(
    {
      Key? key,
      this.buttonColor,
      this.textColor,
      required this.buttonText,
      this.outline = false,
      required this.onPressed
    }
  ) : super(key: key);
     
  final String buttonText;
  final Function onPressed;
  final bool outline;
  final Color? buttonColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    Color? mainColor = buttonColor ?? Theme.of(context).primaryColor;
    Color? tColor = outline ? textColor ?? mainColor : Colors.white;
    Color bColor = outline ? Colors.transparent : mainColor;

    return TextButton(
      onPressed: () {
        onPressed();
      },
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 14.0, 
              color: tColor, 
              fontWeight: FontWeight.w500
            )
          )
        )
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(23),
            side: BorderSide(color: mainColor)
          )
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return outline ? bColor : bColor.withOpacity(0.8);
            }
            return bColor; // Use the component's default.
          },
        )
      )
    );
  }
}
