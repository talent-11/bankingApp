import 'package:flutter/material.dart';
import 'package:fotoc/components/gradient_rectangle.dart';
import 'package:fotoc/components/primary_button.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/footer.dart';

class Signup4Page extends StatefulWidget {
  const Signup4Page({Key? key}) : super(key: key);

  @override
  State<Signup4Page> createState() => _Signup4PageState();
}

class _Signup4PageState extends State<Signup4Page> {
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
                              image: AssetImage("assets/images/wizard07.png"))),
                    ),
                    const GradientRectangle()
                  ],
                )),
            SizedBox(
                width: deviceSize.width,
                height: 388.0,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 36.0),
                        child: Text("Unlock with fingerprint",
                            style: Theme.of(context).textTheme.headline1)),
                    const Spacer(flex: 7),
                    Image.asset("assets/images/fingerprint.png"),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text("Press Touch ID to Proceed",
                          style: Theme.of(context).textTheme.headline5),
                    ),
                    const Spacer(flex: 5),
                    PrimaryButton(
                        buttonText: "GO TO DASHBOARD", onPressed: () {}),
                    const Dots(
                      selectedIndex: 2.0,
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
