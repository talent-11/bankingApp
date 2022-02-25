import 'package:flutter/material.dart';
import 'package:fotoc/components/gradient_rectangle.dart';
import 'package:fotoc/components/primary_button.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/footer.dart';

class Signup2Page extends StatefulWidget {
  const Signup2Page({Key? key}) : super(key: key);

  @override
  State<Signup2Page> createState() => _Signup2PageState();
}

class _Signup2PageState extends State<Signup2Page> {
  void onPressedNext(BuildContext context) {
    Navigator.pushNamed(context, '/wizard/signup/2');
  }

  void onPressedSignin(BuildContext context) {
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage("assets/images/wizard05.png"))),
                    ),
                    const GradientRectangle()
                  ],
                )),
            SizedBox(
                width: deviceSize.width,
                height: 510,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 34.0),
                        child: Text("Select account type",
                            style: Theme.of(context).textTheme.headline1)),
                    const Spacer(flex: 1),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          "I hate peeping Toms. For one thing they usually step all over the hedges and plants on the side of someone's house killing them",
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                        )),
                    const Spacer(flex: 1),
                    PrimaryButton(
                        buttonText: "NEXT",
                        onPressed: () {
                          onPressedNext(context);
                        }),
                    const Dots(
                      selectedIndex: 1.0,
                    ),
                    WizardFooter(
                        description: "Do you have an account?",
                        buttonText: "Sign in here",
                        onPressed: () {
                          onPressedSignin(context);
                        })
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
