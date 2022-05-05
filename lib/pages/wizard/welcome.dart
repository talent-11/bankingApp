import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/components/wizard/text_spans.dart';
import 'package:fotoc/pages/wizard/sidebar.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  void onPressedBar(BuildContext context) {
    _scaffoldState.currentState?.openDrawer();
  }

  void onPressedLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/wizard/login');
  }

  void onPressedSignup(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/wizard/signup');
  }

  IconButton menuButton(BuildContext context) => IconButton(
    icon: const Icon(LineAwesomeIcons.bars, size: 32.0),
    onPressed: () => onPressedBar(context), 
    color: Colors.white,
  );

  Widget titleText(BuildContext context) => Text(
    "Buy, sell & bank outside of the Federal Reserve Banking (FRB) System.",
    style: Theme.of(context).textTheme.headline1,
    textAlign: TextAlign.center,
  );

  Widget bodyText(BuildContext context) => RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      children: [
        TextSpan(
          text: "The currency within FOTOC’s Banking System are digital Constitutional Coins ",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        symbolSpan(height: 18),
        TextSpan(
          text: " (CC) authorized by the interim Constitutional Government (FOTOC), the original Constitution, and the People’s signatures on the Declaration of Restoration.",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ]
    )
  );

  Widget buttons(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
        flex: 1,
        child: SizedBox(
          height: 46,
          child: FotocButton(
            outline: true,
            buttonText: "LOG IN",
            onPressed: () => onPressedLogin(context),
          )
        )
      ),
      const SizedBox(
        width: 16,
      ),
      Expanded(
        flex: 1,
        child: SizedBox(
          height: 46,
          child: FotocButton(
            buttonText: "SIGN UP",
            onPressed: () => onPressedSignup(context),
          )
        )
      )
    ],
  );

  Widget tipText(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Value: ",
        style: Theme.of(context).textTheme.bodyText1,
      ),
      SvgPicture.asset(
        "assets/svgs/cc.svg",
        width: 7.6,
        height: 20,
        color: const Color(0xff98a9bc),
      ),
      Text(
        "1.00 (CC) equal to \$1.00 (USD).",
        style: Theme.of(context).textTheme.bodyText1,
      ),
    ],
  );

  Widget body(BuildContext context) => Expanded(
    flex: 1,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: titleText(context),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: bodyText(context),
        )
      ],
    )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      drawer: const SideBar(),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            LogoBar(iconButton: menuButton(context)),
            body(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
              child: buttons(context),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 12),
              child: tipText(context),
            )
          ],
        ),
      ),
    );
  }
}
