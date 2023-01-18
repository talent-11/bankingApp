import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/pages/statement/statement_final.dart';
import 'package:fotoc/pages/statement/statement_scan.dart';

const descriptions = [
  "We will one-time match checking accounts, savings accounts, retirement accounts, investment accounts (stocks, bonds, mutual funds, Insurance policies with a statement of cash value, CDs, options, futures, and ETFs) and crypto currency accounts.",
  "By Submitting your document and this form you attest to the truth and accuracy of it and agree to be bound by the laws of the Constitutional Government for the United States of America"
];

const errors = [
  "Fields must match your scanned statement.",
  "Information on Statement for Acct Holder must match with information on Individual Acct Holder at FOTOC Bank"
];

const scan_labels = [
  "Acct Name (Bank)",
  "Account Number",
  "Address Line 1",
  "Address Line 2",
  "Address Line 3",
  "Statement Balance",
  "Statement Date"
];

const profile_labels = [
  "Acct Holder",
  "Address Line 1",
  "Address Line 2",
  "Address Line 3",
];

class StatementPreviewPage extends StatefulWidget {
  const StatementPreviewPage({Key? key}) : super(key: key);

  @override
  State<StatementPreviewPage> createState() => _StatementPreviewPageState();
}

class _StatementPreviewPageState extends State<StatementPreviewPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onPressedAnother(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StatementScanPage()));
  }

  void onPressedFinish(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const StatementFinalPage()));
  }

  void onPressedCancel(BuildContext context) {
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count ++ == 3;
    });
  }

  Widget decorateScanValues(BuildContext context) {
    List<Widget> items = [];

    for (int i = 0; i < scan_labels.length; i ++) {
      items.add(decorateItem(context, scan_labels[i], '300'));
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12)
      ),
      child: Column(children: items),
    );
  }

  Widget decorateProfileValues(BuildContext context) {
    List<Widget> items = [];

    for (int i = 0; i < profile_labels.length; i ++) {
      items.add(decorateItem(context, profile_labels[i], '300'));
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12)
      ),
      child: Column(children: items),
    );
  }

  Widget decorateItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xff252631),
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xff98a9bc),
              fontSize: 14,
            ),
          )
        ],
      )
    );
  }

  Widget decorateComment(BuildContext context, String comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        comment,
        style: const TextStyle(
          color: Colors.redAccent,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      )
    );
  }

  List<Widget> decorateBody(BuildContext context) {
    var widgets = <Widget>[];

    widgets.add(decorateComment(context, errors[0]));

    widgets.add(decorateScanValues(context));

    widgets.add(const SizedBox(height: 4));

    widgets.add(decorateComment(context, errors[1]));

    widgets.add(decorateProfileValues(context));

    widgets.add(const SizedBox(height: 8));
 
    widgets.add(
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: descriptions[0],
          style: const TextStyle(
            color: Color(0xff252631),
            fontSize: 14,
            height: 1.4,
          ),
        )
      ),
    );
 
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 92,
              height: 40,
              child: FotocButton(
                outline: true,
                buttonText: "Cancel",
                onPressed: () {
                  onPressedCancel(context);
                },
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 112,
              height: 40,
              child: FotocButton(
                buttonText: "Another",
                onPressed: () {
                  onPressedAnother(context);
                },
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 112,
              height: 40,
              child: FotocButton(
                buttonText: "Finish",
                onPressed: () {
                  onPressedFinish(context);
                },
              ),
            ),
          ]
        )
      ),
    );

    widgets.add(const SizedBox(height: 12));
 
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 12),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: descriptions[1],
            style: const TextStyle(
              color: Color(0xff252631),
              fontSize: 14,
              height: 1.4,
            ),
          )
        ),
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
