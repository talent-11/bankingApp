import 'package:flutter/material.dart';
import 'package:fotoc/components/gradient_rectangle.dart';
import 'package:fotoc/components/primary_button.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/footer.dart';

const description = "Get your Test Account here:\nProvide us with your name and email address and you will instantly receive (cc) 100.00 to spend.";

class SignupStartPage extends StatefulWidget {
  const SignupStartPage({Key? key}) : super(key: key);

  @override
  State<SignupStartPage> createState() => _SignupStartPageState();
}

class _SignupStartPageState extends State<SignupStartPage> {
  void onPressedGetStarted(BuildContext context) {
    Navigator.pushNamed(context, '/wizard/signup/main');
  }

  void onPressedSignin(BuildContext context) {
    // Navigator.pushNamed(context, '/');
    Navigator.pushReplacementNamed(context, '/wizard/login');
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var imageNum = 4;
    var imageSrc = "assets/images/wizard0$imageNum.png";

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
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage(imageSrc))),
                    ),
                    const GradientRectangle()
                  ],
                )),
            SizedBox(
                width: deviceSize.width,
                height: 308,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Text("Create your account",
                            style: Theme.of(context).textTheme.headline1)),
                    const Spacer(flex: 1),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          description,
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                        )),
                    const Spacer(flex: 1),
                    PrimaryButton(
                        buttonText: "GET STARTED",
                        onPressed: () {
                          onPressedGetStarted(context);
                        }),
                    const Dots(
                      selectedIndex: 0,
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
