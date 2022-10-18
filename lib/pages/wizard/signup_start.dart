import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/primary_button.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/footer.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:provider/provider.dart';
import 'package:fotoc/services/validation_service.dart';

const description = "Provide us with your name and email address and you will instantly receive (cc) 100.00 to spend.";

class SignupStartPage extends StatefulWidget {
  const SignupStartPage({Key? key}) : super(key: key);

  @override
  State<SignupStartPage> createState() => _SignupStartPageState();
}

class _SignupStartPageState extends State<SignupStartPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _friendReferralId;


  void onPressedGetStarted(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<CurrentAccount>().changeAccount(AccountModel(friendId: _friendReferralId));
      Navigator.pushNamed(context, '/wizard/signup/main');
    }
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
