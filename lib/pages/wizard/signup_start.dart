import 'package:flutter/material.dart';
import 'package:fotoc/components/primary_button.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/footer.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';

const description = "Provide us with your name and email address and you will instantly receive (cc) 100.00 to spend.";

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
    Navigator.pushReplacementNamed(context, '/wizard/login');
  }

  Widget body(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Text(
        "Get your Test Account here",
        style: Theme.of(context).textTheme.headline1
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Text(
          description,
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        )
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: TextInputField(
          labelText: "Enter the Individual's code who referred you to FOTOC Bank",
          hintText: "Enter a code",
        )
      ),
    ],
  );

  Widget footer(BuildContext context) => Column(
    children: [
      PrimaryButton(
        buttonText: "GET STARTED",
        onPressed: () {
          onPressedGetStarted(context);
        }
      ),
      const Dots(selectedIndex: 0),
      WizardFooter(
        description: "Do you have an account?",
        buttonText: "Sign in here",
        onPressed: () {
          onPressedSignin(context);
        }
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        // color: Colors.white,
        children: [
          const LogoBar(),
          SizedBox(
            height: (deviceSize.height - 148.4 - logoHeight),
            child: body(context)
          ),
          footer(context)
        ],
      )
    );
  }
}
