import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/text_spans.dart';

const titles = [
  "How do I get the money I have now into FOTOC Bank?",
  "In addition (For Businesses only):",
  "What about Cash? How can I get my Cash converted to (CC's)",
  "But, before Banks are accepted into the FOTOC Banking System and for a Limited time only:",
];

const descriptions = [
  " Individuals and businesses who submit documents (bank/account statement(s)) will receive matching funds into their account at FOTOC Bank. This is a onetime matching of funds: Value = \$ (Dollar) for (CC's). For matching of funds in other currency systems: the current exchange rate to convert the currencies of countries not on the \$ (Dollar). At some point (your choice) after signing up for/obtaining a verified account with FOTOC Bank, our system will scan (OCR) the documents that you provide. Provide us with a statement (only one statement for each account will be accepted) dated any time after January 1st 2019 (Pick your highest balance statement for maximum benefit) and we will match that dollar amount with an equal amount of (CC's). We will match checking accounts, savings accounts, retirement accounts, investment account (stocks, bonds, mutual funds, Insurance policies with a statement of cash value, CDs, options, futures, and ETFs) and crypto currency accounts.",
  " At some point (your choice) after signing up for/obtaining a verified Business account with FOTOC Bank, our system will scan (OCR) the document that you provide. Provide us with a year-end financial statement (only one year-end financial statement for each Business will be accepted) for any year 2019 or after (Pick your highest net sales year-end statement for maximum benefit) and your Business account will receive 10% of that year's net annual sales - credited to your account at FOTOC Bank.",
  " In the near future, the \"FEDERAL RESERVE SYSTEM\" will end everyone's ability to buy or sell with cash as they try to force everyone into their NWO (New World Order) artificial intelligence cashless digital currency system. They will most likely get rid of banks as well. FOTOC's Banking System will soon be accepting Banks into our Banking System and we will be matching the funds they have in the FEDERAL RESERVE BANKING SYSTEM.",
  " You can convert your cash (U.S. Dollars only) into a U.S. money order or U.S. Cashier's Check (personal/business checks not accepted), or a debit card, credit card, Visa/MasterCard git card and donate your FEDERAL RESERVE money through our main website {{cdonation portal here:}} we will not only match your funds, but you will receive 100 times (in {{s}}'s) the amount of your donation - Which will be credited into your account with FOTOC Bank. For example: If you donate \$3,500 {{cthrough this portal:}} you will instantly receive 350,000 ({{s}}'s) credited into your account at FOTOC Bank.",
];

class VerifyStepNeedPage extends StatefulWidget {
  const VerifyStepNeedPage({Key? key}) : super(key: key);

  @override
  State<VerifyStepNeedPage> createState() => _VerifyStepNeedPageState();
}

class _VerifyStepNeedPageState extends State<VerifyStepNeedPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

    for (var i = 0; i < titles.length; i ++) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(
            top: i == 0 ? 0.0 : 12.0,
            bottom: 8
          ),
          child: Text(
            titles[i],
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          )
        )
      );
      widgets.add(
        RichText(
          text: TextSpan(
            children: decorateArticle(context, descriptions[i])
          )
        )
      );
    }
       
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
