import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/buttons_bar.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/pages/business/business_verify_1.dart';

const title = "Obtain a Verified Business Account";

const subTitle = "Here's a short list of what your business will receive:";

const descriptions = [
  "* We will match the funds you have in other currency systems 100% (Highest balance monthly statement 2019 or after).",
  "* In addition, we will credit 10% of your best year's annual sales (2019 or after) - to your verified account at FOTOC Bank.",
  "* 3% interest paid on your savings.",
  "* Even if your business went out of business (2020 or after) you can open an account and have your funds matched (from 2019 or after statements).",
];

class BusinessVerify0Page extends StatefulWidget {
  const BusinessVerify0Page({Key? key}) : super(key: key);

  @override
  State<BusinessVerify0Page> createState() => _BusinessVerify0PageState();
}

class _BusinessVerify0PageState extends State<BusinessVerify0Page> {

  void onPressedCancel(BuildContext context) {
    Navigator.pop(context);
  }

  void onPressedSignup(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const BusinessVerify1Page()));
  }

  List<Widget> decorateBody(BuildContext context) {
    var widgets = <Widget>[];

    widgets.add(const SizedBox(height: 32));

    widgets.add(Center(child: Text(title, style: Theme.of(context).textTheme.headline1)));

    widgets.add(const SizedBox(height: 32));

    widgets.add(Text(subTitle, style: Theme.of(context).textTheme.headline5));

    widgets.add(const SizedBox(height: 16));

    for (var i = 0; i < descriptions.length; i ++) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4), 
          child: RichText(
            text: TextSpan(
              text: descriptions[i],
              style: Theme.of(context).textTheme.bodyText1,
            )
          )
        )
      );
    }

    widgets.add(const SizedBox(height: 20));
    
    widgets.add(
      ButtonsBar(
        height: 40, 
        widths: const [120, 120], 
        labels: const ["Cancel", "Sign Up"], 
        outlines: const [true, false],
        functions: [() => onPressedCancel(context), () => onPressedSignup(context)]
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
          )
        ],
      )
    );
  }
}
