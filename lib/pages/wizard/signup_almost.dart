import 'package:flutter/material.dart';
import 'package:fotoc/components/gradient_rectangle.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/footer.dart';

const description = "Try us out before becoming a fully";
const link = "Verified Account Holder:";
const notify = "Open your confirmation email and\nclick \"Verify Email\" button at there";

class SignupAlmostPage extends StatefulWidget {
  const SignupAlmostPage({Key? key}) : super(key: key);

  @override
  State<SignupAlmostPage> createState() => _SignupAlmostPageState();
}

class _SignupAlmostPageState extends State<SignupAlmostPage> {
  void onPressedSignin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/wizard/login');
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
                      child: Text("Almost Done!", style: Theme.of(context).textTheme.headline1)),
                    const Spacer(flex: 1),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.center),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        link,
                        style: Theme.of(context).textTheme.headline6),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
                      child: Text(
                        notify,
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center),
                    ),
                    const Spacer(flex: 1),
                    const Dots(
                      selectedIndex: 3,
                      dots: 4,
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
