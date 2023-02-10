import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const double logoHeight = 168;

class LogoBar extends StatelessWidget {
  const LogoBar({Key? key, this.iconButton}) : super(key: key);

  final IconButton? iconButton;

  List<Widget> decorate(BuildContext context) {
    var widget = <Widget>[];
    widget.add(Container(
      width: MediaQuery.of(context).size.width,
      height: logoHeight,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: SvgPicture.asset(
        "assets/svgs/logo.svg",
        width: 118,
        height: 120,
        color: Colors.white,
      ),
    ));

    if (iconButton != null) {
      widget.add(iconButton!);
    }

    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const Alignment(-0.9, -0.64),
      children: decorate(context),
    );
  }
}
