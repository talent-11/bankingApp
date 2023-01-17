import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/components/wizard/text_spans.dart';

const titles = [
  "How do I get the money I have now into FOTOC Bank?",
  "In addition (For Businesses only):",
  "What about Cash?",
  " How can I get my Cash converted to {{ss}}?",
];

const descriptions = [
  " Individuals and businesses who submit documents (bank/account statement(s)) will receive matching funds into their account at FOTOC Bank. This is a onetime matching of funds: Value = \$ (Dollar) for (CC's). For matching of funds in other currency systems: the current exchange rate to convert the currencies of countries not on the \$ (Dollar).",
  " At some point (your choice) after signing up for/obtaining a verified account with FOTOC Bank, our system will scan (OCR) the documents that you provide. Provide us with a statement (only one statement for each account will be accepted) dated any time after January 1st 2019 (Pick your highest balance statement for maximum benefit) and we will match that dollar amount with an equal amount of (CC's). We will match checking accounts, savings accounts, retirement accounts, investment account (stocks, bonds, mutual funds, Insurance policies with a statement of cash value, CDs, options, futures, and ETFs) and crypto currency accounts.",
  " (You must first have an Individual Verified Account to open/obtain a Verified Business Account). At some point (your choice) after signing up for/obtaining a verified Business account with FOTOC Bank, our system will scan (OCR) the document that you provide. Provide us with a year-end financial statement (only one year-end financial statement for each Business will be accepted) for any year 2019 or after (Pick your highest net sales year-end statement for maximum benefit) and your Business account will receive 10% of that year's net annual sales - credited to your account at FOTOC Bank.",
];

class StatementInformationPage extends StatefulWidget {
  const StatementInformationPage({Key? key}) : super(key: key);

  @override
  State<StatementInformationPage> createState() => _StatementInformationPageState();
}

class _StatementInformationPageState extends State<StatementInformationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onPressedMatch(BuildContext context) {
    
  }

  void onPressedAboutCash(BuildContext context) {
    Navigator.pushNamed(context, '/statement/about-cash');
  }

  void onPressedBack(BuildContext context) {
    Navigator.pop(context);
  }

  IconButton backButton(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back_ios, size: 32.0),
    onPressed: () => onPressedBack(context), 
    color: Colors.white,
  );

  List<Widget> decorateBody(BuildContext context) {
    var widgets = <Widget>[];

    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 8),
        child: Text(
          titles[0],
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        )
      )
    );
    
    widgets.add(
      RichText(
        text: TextSpan(
          children: decorateArticle(context, descriptions[0])
        )
      )
    );
    
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8), 
        child: RichText(
          text: TextSpan(
            children: decorateArticle(context, descriptions[1])
          )
        )
      )
    );
    
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: RichText(
          text: TextSpan(
            text: titles[1],
            style: const TextStyle(
              color: Color(0xff252631),
              fontSize: 15,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            children: [
              TextSpan(
                text: descriptions[2],
                style: const TextStyle(
                  color: Color(0xff98a9bc),
                  fontSize: 14,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                  height: 1.4,
                ),
              )
            ]
          )
        ),
      )
    );
 
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: titles[2],
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 15,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => {
              onPressedAboutCash(context)
            },
            children: [
              TextSpan(
                style: const TextStyle(
                  color: Color(0xff98a9bc),
                  fontSize: 14,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                  height: 1.4,
                ),
                children: decorateArticle(context, titles[3]),
                recognizer: TapGestureRecognizer()..onTap = null,
              )
            ]
          )
        ),
      )
    );
 
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(
          "Have your documents ready and click the \"Match my Funds\" button:",
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        )
      ),
    );
 
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: SizedBox(
          width: 160,
          height: 40,
          child: FotocButton(
            buttonText: "Match my Funds",
            onPressed: () {
              onPressedMatch(context);
            }
          ),
        )
      ),
    );
      
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LogoBar(iconButton: backButton(context)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
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
