import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/pages/statement/statement_scan.dart';

const description = "Before you begin, make sure you have one monthly statement for every account that you want matched. You will not be able to com back and upload monthly statements a second time. We only match funds one time! Once you upload all your statements and submit, your one time matching is complete!";

class StatementNotifyPage extends StatefulWidget {
  const StatementNotifyPage({Key? key}) : super(key: key);

  @override
  State<StatementNotifyPage> createState() => _StatementNotifyPageState();
}

class _StatementNotifyPageState extends State<StatementNotifyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onPressedContinue(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StatementScanPage()));
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
        padding: const EdgeInsets.only(top: 0, bottom: 12),
        child: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            text: description,
            style: TextStyle(
              color: Color(0xff252631),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          )
        ),
      )
    );
 
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: SizedBox(
          width: 160,
          height: 40,
          child: FotocButton(
            buttonText: "Continue",
            onPressed: () {
              onPressedContinue(context);
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
