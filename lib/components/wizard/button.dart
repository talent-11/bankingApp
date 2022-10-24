import 'package:flutter/material.dart';

class FotocButton extends StatelessWidget {
  const FotocButton(
    {
      Key? key,
      this.buttonColor,
      this.textColor,
      required this.buttonText,
      this.outline = false,
      required this.onPressed,
      this.loading = false,
    }
  ) : super(key: key);
     
  final String buttonText;
  final Function onPressed;
  final bool outline;
  final bool loading;
  final Color? buttonColor;
  final Color? textColor;

  List<Widget> decorateContents(BuildContext context, Color tColor) {
    var widgets = <Widget>[];

    if (loading) {
      widgets.add(
        const SizedBox(
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,),
          height: 20.0,
          width: 20.0,
        )
      );
      widgets.add(const SizedBox(width: 8));
    }

    widgets.add(Text(buttonText, style: TextStyle(fontSize: 14.0, color: tColor, fontWeight: FontWeight.w500)));

    return widgets;
  }

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: decorateContents(context, tColor)
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
