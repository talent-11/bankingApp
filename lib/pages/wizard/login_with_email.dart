import 'package:flutter/material.dart';
import 'package:fotoc/components/primary_button.dart';
import 'package:fotoc/components/wizard/footer.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';

class LoginWithEmailPage extends StatefulWidget {
  const LoginWithEmailPage({Key? key}) : super(key: key);

  @override
  State<LoginWithEmailPage> createState() => _LoginWithEmailPageState();
}

class _LoginWithEmailPageState extends State<LoginWithEmailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onPressedRecover(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/wizard/login/recover');
  }

  void onPressedSignup(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/wizard/signup/0');
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
                              image: AssetImage("assets/images/wizard01.png"))),
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
            SizedBox(
                width: deviceSize.width,
                height: 428.0,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Text("Sign in to your account",
                            style: Theme.of(context).textTheme.headline1)),
                    Padding(
                        padding: const EdgeInsets.only(top: 22.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Padding(
                                  padding: EdgeInsets.only(top: 14.0),
                                  child: TextInputField(
                                    labelText: "Your account",
                                    hintText: "Enter your email or phone",
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(top: 14.0),
                                  child: TextInputField(
                                    labelText: "Password",
                                    hintText: "Enter your password",
                                  )),
                            ],
                          ),
                        )),
                    const Spacer(flex: 1),
                    TextButton(
                        onPressed: () {
                          onPressedRecover(context);
                        },
                        child: Text("Recover password",
                            style: Theme.of(context).textTheme.headline6)),
                    const Spacer(flex: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                      child: PrimaryButton(
                          buttonText: "SIGN IN", onPressed: () {}),
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
