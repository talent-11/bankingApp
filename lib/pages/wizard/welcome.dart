import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/components/wizard/text_spans.dart';
import 'package:fotoc/pages/individual/verify_step_0.dart';
import 'package:fotoc/pages/wizard/sidebar.dart';

const titles = [
  "FOTOC Bank is the Monetary System for all the People and all of the Constitutional Governments throughout the world, authorized by We the People.",
  "Where you buy, sell & bank outside of the FEDERAL RESERVE BANKING (FBR) SYSTEM."
];

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  void onPressedBar(BuildContext context) {
    _scaffoldState.currentState?.openDrawer();
  }

  void onPressedTest(BuildContext context) {
    Navigator.pushNamed(context, '/wizard/signup/start');
  }

  void onPressedLogin(BuildContext context) {
    // Navigator.pushReplacementNamed(context, '/wizard/login');
    Navigator.pushNamed(context, '/wizard/login');
  }

  void onPressedSignup(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const VerifyStep0Page()));
  }

  IconButton menuButton(BuildContext context) => IconButton(
    icon: const Icon(Icons.menu, size: 32.0),
    onPressed: () => onPressedBar(context), 
    color: Colors.white,
  );

  Widget titleText(BuildContext context, String str) => Text(
    str,
    style: Theme.of(context).textTheme.headline5,
    textAlign: TextAlign.center,
  );

  Widget descriptionText(BuildContext context) => RichText(
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

  Widget titleText1(BuildContext context) => RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      children: [
        TextSpan(
          text: "We will give you ",
          style: Theme.of(context).textTheme.headline5,
        ),
        symbolSpan(height: 18, color: const Color(0xff252631)),
        TextSpan(
          text: "100 (CC) to spend just to take FOTOC Bank out for a \"test drive.\"",
          style: Theme.of(context).textTheme.headline5,
        ),
      ]
    )
  );

  Widget titleText2(BuildContext context) => RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      children: [
        TextSpan(
          text: "Open a fully verified account and receive ",
          style: Theme.of(context).textTheme.headline5,
        ),
        symbolSpan(height: 18, color: const Color(0xff252631)),
        TextSpan(
          text: "10,000 CC.",
          style: Theme.of(context).textTheme.headline5,
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
            buttonText: "SIGN UP",
            onPressed: () => onPressedSignup(context),
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
            outline: true,
            buttonText: "LOG IN",
            onPressed: () => onPressedLogin(context),
          )
        )
      ),
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

  Widget descriptionText1(BuildContext context) => RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      children: [
        TextSpan(
          text: "Every time you refer someone to sign up for a fully verified account with your referral code, you will receive ",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        symbolSpan(height: 18),
        TextSpan(
          text: " 1,000 CC.",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ]
    )
  );

  Widget body(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: titleText(context, titles[0]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: titleText(context, titles[1]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: descriptionText(context),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: tipText(context),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: titleText2(context),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: buttons(context),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: descriptionText1(context),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: titleText1(context),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: SizedBox(
          width: 200,
          height: 46,
          child: FotocButton(
            buttonText: "Get Test Account",
            onPressed: () => onPressedTest(context),
          )
        )
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      drawer: const SideBar(),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(children: [
            LogoBar(iconButton: menuButton(context)),
            body(context),
          ]),
        ),
      ),
    );
  }
}
