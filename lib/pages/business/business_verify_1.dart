import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:fotoc/components/ui/buttons_bar.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/pages/business/business_verify_2.dart';
import 'package:fotoc/pages/individual/verify_step_need.dart';

const title = "What you will need to obtain a Verified Business Account:";

const descriptions = [
  "1. Fill out our form with your business information.",
  "2. Upload the appropriate business documents that shows the business name, your name as primary business owner and the Tax ID number for the business. This is necessary to validate the existence of your business your primary ownership of the business (this ID number is only used for validation purposes). You will receive a new Business Identification number with FOTOC's monetary system (this is not a part of the FEDERAL RESERVE SYSTEM) upon account validation. ",
  "3. Must agree to messaging, notifications, emails and updates.",
  "4. Must agree to operate your business as set forth in the ",
  "5. Optional: matching your funds either during sign-up or at a later date. ",
];

class BusinessVerify1Page extends StatefulWidget {
  const BusinessVerify1Page({Key? key}) : super(key: key);

  @override
  State<BusinessVerify1Page> createState() => _BusinessVerify1PageState();
}

class _BusinessVerify1PageState extends State<BusinessVerify1Page> {
  void onPressedYes(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const BusinessVerify2Page()));
  }

  void onPressedNeed() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const VerifyStepNeedPage()));
  }

  void onPressedNo(BuildContext context) {
    Navigator.pop(context);
  }

  List<Widget> decorateBody(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          ),
        )
      )
    );
    for (var i = 0; i < descriptions.length; i ++) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4), 
          child: RichText(
            text: TextSpan(
              text: descriptions[i],
              style: Theme.of(context).textTheme.bodyText1,
              children: i == 4 ? 
                [
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
                ] : 
                i == 3 ? 
                  [
                    TextSpan(
                      text: "Declaration of Restoration",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () => {
                        // onPressedNeed()
                      },
                    )
                  ] :
                  i == 1 ?
                  [
                    TextSpan(
                      text: "The information on your business document must match the information your provide in step 1.",
                      style: Theme.of(context).textTheme.headline5
                    )
                  ] :
                  [],
            )
          )
        )
      );
    }
    widgets.add(
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 16),
          child: Text(
            "Ready to obtain your Business Account?",
            style: Theme.of(context).textTheme.headline5,
          ),
        )
      )
    );
    widgets.add(
      ButtonsBar(
        height: 40, 
        widths: const [120, 120], 
        labels: const ["No", "Yes"], 
        outlines: const [true, false],
        functions: [() => onPressedNo(context), () => onPressedYes(context)]
      )
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: decorateBody(context)
              )
            )
          ),
        ],
      )
    );
  }
}
