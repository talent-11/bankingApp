import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/primary_button.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/footer.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';
import 'package:fotoc/pages/wizard/login.dart';
import 'package:fotoc/pages/wizard/signup_main.dart';
import 'package:fotoc/services/validation_service.dart';

const descriptions = [
  "Provide us with your name and email address and you will instantly receive (cc) 100.00 to spend.",
  "Test accounts are only for spending money. A test account cannot receive money.",
];

class SignupStartPage extends StatefulWidget {
  const SignupStartPage({Key? key, this.from}) : super(key: key);

  final String? from;

  @override
  State<SignupStartPage> createState() => _SignupStartPageState();
}

class _SignupStartPageState extends State<SignupStartPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _friendReferralId;


  void onPressedGetStarted(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.push(context, MaterialPageRoute(builder: (_) => SignupMainPage(from: widget.from, friendId: _friendReferralId)));
    }
  }

  void onPressedSignin(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  Widget body(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Text(
        "Get your Account here",
        style: Theme.of(context).textTheme.headline1
      ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
            child: Text(
              descriptions[0],
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
            child: Text(
              descriptions[1],
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            )
          )
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: TextInputField(
            labelText: "Enter the Individual's code who referred you to FOTOC Bank",
            hintText: "Enter a code",
            onSaved: (val) => _friendReferralId = val!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              } else if (!value.isValidReferralId) {
                return 'Please enter valid your friend\'s referral id';
              }
              return null;
            },
          )
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
      widget.from == 'verify' ? const Dots(selectedIndex: 0, dots: 6) : const Dots(selectedIndex: 0, dots: 3),
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
