import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/components/wizard/text_spans.dart';

const titles = [
  "What about Cash?",
  " How can I get my Cash converted to {{ss}}?",
  "But, before Banks are accepted into the FOTOC Banking System and for a Limited time only:"
];

const descriptions = [
  " In the near future, the \"FEDERAL RESERVE SYSTEM\" will end everyone's ability to buy or sell with cash as they try to force everyone into their NWO (New World Order) artificial intelligence cashless digital currency system. They will most likely get rid of banks as well. FOTOC's Banking System will soon be accepting Banks into our Banking System and we will be matching the funds they have in the FEDERAL RESERVE BANKING SYSTEM.",
  " You can convert your cash (U.S. Dollars only) into a U.S. money order or U.S. Cashier's Check (personal/business checks not accepted), or a debit card, credit card, Visa/MasterCard git card and donate your FEDERAL RESERVE money through our main website {{cdonation portal here:}} we will not only match your funds, but you will receive 100 times (in {{s}}'s) the amount of your donation - Which will be credited into your account with FOTOC Bank. For example: If you donate \$3,500 {{cthrough this portal:}} you will instantly receive 350,000 ({{s}}'s) credited into your account at FOTOC Bank.",
];

class StatementAboutCashPage extends StatefulWidget {
  const StatementAboutCashPage({Key? key}) : super(key: key);

  @override
  State<StatementAboutCashPage> createState() => _StatementAboutCashPageState();
}

class _StatementAboutCashPageState extends State<StatementAboutCashPage> {
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
 
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 12),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: titles[0],
            style: const TextStyle(
              color: Color(0xff252631),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            children: decorateArticle(context, titles[1], fontSize: 15, color: const Color(0xff252631), fontWeight: FontWeight.w500)
          )
        ),
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
        padding: const EdgeInsets.only(top: 12, bottom: 0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: titles[2],
            style: const TextStyle(
              color: Color(0xff252631),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.4,
              decoration: TextDecoration.underline
            ),
            // children: decorateArticle(context, titles[1], fontSize: 15, color: const Color(0xff252631), fontWeight: FontWeight.w500)
          )
        ),
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
    
    // widgets.add(
    //   Padding(
    //     padding: const EdgeInsets.only(top: 12),
    //     child: RichText(
    //       text: TextSpan(
    //         text: titles[1],
    //         style: const TextStyle(
    //           color: Color(0xff252631),
    //           fontSize: 15,
    //           decoration: TextDecoration.underline,
    //           fontWeight: FontWeight.w500,
    //           height: 1.4,
    //         ),
    //         children: [
    //           TextSpan(
    //             text: descriptions[2],
    //             style: const TextStyle(
    //               color: Color(0xff98a9bc),
    //               fontSize: 14,
    //               decoration: TextDecoration.none,
    //               fontWeight: FontWeight.normal,
    //               height: 1.4,
    //             ),
    //           )
    //         ]
    //       )
    //     ),
    //   )
    // );
      
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
