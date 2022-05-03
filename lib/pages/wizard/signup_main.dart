import 'package:flutter/material.dart';
import 'package:fotoc/components/gradient_rectangle.dart';
import 'package:fotoc/components/primary_button.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/footer.dart';
import 'package:fotoc/components/wizard/labeled_checkbox.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';

class SignupMainPage extends StatefulWidget {
  const SignupMainPage({Key? key}) : super(key: key);

  @override
  State<SignupMainPage> createState() => _SignupMainPageState();
}

class _SignupMainPageState extends State<SignupMainPage> {
  bool agreed = false;

  void onPressedNext(BuildContext context) {
    Navigator.pushNamed(context, '/wizard/signup/almost');
  }

  void onPressedSignin(BuildContext context) {
    Navigator.pushNamed(context, '/wizard/login');
  }

  List<Widget> decorate(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 24.0, bottom: 16),
        child: Text(
          "Account details",
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        )
      )
    );
    widgets.add(
      const Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: TextInputField(
          // labelText: "Your name",
          hintText: "Enter your full name",
        )
      )
    );
    widgets.add(
      const Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: TextInputField(
          // labelText: "Your account",
          hintText: "Enter your email",
        )
      )
    );
    widgets.add(
      const Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: TextInputField(
          // labelText: "Create password",
          hintText: "Enter your password",
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 20.0),
        child: LabeledCheckbox(
          labelText: "I agree with terms & conditions",
          checked: agreed,
          valueChanged: (bool? value) {
            setState(() {
              agreed = value!;
            });
          }
        )
      )
    );
    return widgets;
  }

  Widget footer(BuildContext context) => Column(
    children: [
      PrimaryButton(
        buttonText: "GET STARTED",
        onPressed: () {
          onPressedNext(context);
        }
      ),
      const Dots(selectedIndex: 1),
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
        children: [
          const LogoBar(),
          SizedBox(
            height: (deviceSize.height - 148.4 - 216),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: decorate(context),
            )
          ),
          footer(context),
        ],
      ),
    );
  }
}
