import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';

const descriptions = [
  "1. Fill out our form with your information.",
  "2. Upload 2 forms of ID. Primary ID must be verifiable Photo ID issued by local or national government. Second ID: passport, credit card, institutional ID, or an alternate form to be considered like a cell phone bill, electric bill, mortgage bill, etc.) All information must be verifiable. Full name, Physical Address. Email. A cell phone and two-factor authentication required for first time sign up/establish a fully verified account. -Your ID(s) must match the information you input in step one.",
  "3. Must agree to messaging, notifications, emails and updates.",
  "4. Must read and sign the Declaration of Restoration - and agree to abide by its principles as well as the Constitution.",
  "5. Optional: matching your funds either during sign-up or at a later date. ",
];

class VerifyStep0Page extends StatefulWidget {
  const VerifyStep0Page({Key? key}) : super(key: key);

  @override
  State<VerifyStep0Page> createState() => _VerifyStep0PageState();
}

class _VerifyStep0PageState extends State<VerifyStep0Page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onPressedYes(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/free/verify/1');
  }

  void onPressedNeed() {
    Navigator.pushNamed(context, '/free/verify/need');
  }

  void onPressedNo(BuildContext context) {
    Navigator.pop(context);
  }

  List<Widget> decorateBody(BuildContext context) {
    var widgets = <Widget>[];
    for (var i = 0; i < descriptions.length; i ++) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4), 
          child: RichText(
            text: TextSpan(
              text: descriptions[i],
              style: Theme.of(context).textTheme.bodyText1,
              children: i == (descriptions.length - 1) ? [
                TextSpan(
                  text: "What will I need?",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () => {
                    onPressedNeed()
                  },
                )
              ] : [],
            )
          )
        )
      );
    }
    widgets.add(
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 20),
          child: Text(
            "Ready to obtain your Verified Account?",
            style: Theme.of(context).textTheme.headline5,
          ),
        )
      )
    );
    widgets.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 120,
            child: FotocButton(
              outline: true,
              buttonText: "No",
              onPressed: () {
                onPressedNo(context);
              },
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 120,
            height: 40,
            child: FotocButton(
              buttonText: "Yes",
              onPressed: () {
                onPressedYes(context);
              },
            ),
          )
        ]
      ),
    );
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const LogoBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: decorateBody(context)
                ),
              )
            )
          ),
        ],
      )
    );
  }
}
