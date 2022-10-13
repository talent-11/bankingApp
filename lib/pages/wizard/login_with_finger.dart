import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/primary_button.dart';
import 'package:fotoc/components/wizard/footer.dart';

class LoginWithFingerPage extends StatefulWidget {
  const LoginWithFingerPage({Key? key}) : super(key: key);

  @override
  State<LoginWithFingerPage> createState() => _LoginWithFingerPageState();
}

class _LoginWithFingerPageState extends State<LoginWithFingerPage> {
  void onPressedChangeLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/wizard/login/email');
  }

  void onPressedSignup(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/wizard/signup');
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
            SizedBox(
                width: deviceSize.width,
                height: 388.0,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage("assets/images/wizard02.png"))),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: FractionalOffset.bottomRight,
                        end: FractionalOffset.topLeft,
                        colors: [
                          const Color(0xff2a14f6).withOpacity(0.6),
                          const Color(0xffe409f9).withOpacity(0.6)
                        ],
                      )),
                    )
                  ],
                )),
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Text("Sign in to your account",
                            style: Theme.of(context).textTheme.headline1)),
                    const Spacer(flex: 7),
                    Image.asset("assets/images/fingerprint.png"),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text("Use Touch ID to Sign In",
                          style: Theme.of(context).textTheme.headline5),
                    ),
                    const Spacer(flex: 5),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                      child: PrimaryButton(
                          buttonText: "CHANGE LOGIN DETAILS",
                          onPressed: () {
                            onPressedChangeLogin(context);
                          }),
                    ),
                    WizardFooter(
                        description: "Don't have an account?",
                        buttonText: "Sign up here",
                        onPressed: () {
                          onPressedSignup(context);
                        })
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
