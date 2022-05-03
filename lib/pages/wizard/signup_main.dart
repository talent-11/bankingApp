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
        padding: const EdgeInsets.only(top: 24.0),
        child: Text(
          "Account details",
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        )
      )
    );
    widgets.add(
      const Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: TextInputField(
          // labelText: "Your name",
          hintText: "Enter your full name",
        )
      )
    );
    widgets.add(
      const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: TextInputField(
          // labelText: "Your account",
          hintText: "Enter your email",
        )
      )
    );
    widgets.add(
      const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: TextInputField(
          // labelText: "Create password",
          hintText: "Enter your password",
        )
      )
    );
    // widgets.add(
    //   const Padding(
    //     padding: EdgeInsets.only(top: 8.0),
    //     child: TextInputField(
    //       labelText: "Enter the Individual's code who referred you to FOTOC Bank",
    //       hintText: "Enter a code",
    //     )
    //   )
    // );
    // widgets.add(
    //   const Spacer(flex: 1)
    // );
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
    // widgets.add(
    //   const Spacer(flex: 1)
    // );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: PrimaryButton(
          buttonText: "NEXT",
          onPressed: () => onPressedNext(context)
        ),
      )
    );
    widgets.add(
      const Dots(selectedIndex: 1.0)
    );
    widgets.add(
      WizardFooter(
        description: "Do you have an account?",
        buttonText: "Sign in here",
        onPressed: () => onPressedSignin(context)
      )
    );
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            const LogoBar(),
            Expanded(
              flex: 1,
              child: ListView(
                padding: EdgeInsets.zero,
                children: decorate(context),
              )
            ),
          ],
        ),
      ),
    );
  }
}
