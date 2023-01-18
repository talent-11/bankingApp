import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/pages/statement/statement_scan.dart';

const descriptions = [
  "Once you click this button, you will not be able to go back and make any changes, and you will have completed your one time matching of funds.",
  "This is your only chance to submit one statement for each of your accounts that you want matched.",
  "If there is anything wrong on these forms, do not submit. Either go back and correct or start the process over again."
];

const banks = [
  "Bank of America",
  "Commerce Bank"
];

class StatementFinalPage extends StatefulWidget {
  const StatementFinalPage({Key? key}) : super(key: key);

  @override
  State<StatementFinalPage> createState() => _StatementFinalPageState();
}

class _StatementFinalPageState extends State<StatementFinalPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onPressedSubmit(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void onPressedCancel(BuildContext context) {
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count ++ == 3;
    });
  }

  Widget decorateScanValues(BuildContext context) {
    List<Widget> items = [];

    for (int i = 0; i < banks.length; i ++) {
      items.add(decorateItem(context, i.toString(), banks[i], '\$300.00'));
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12)
      ),
      child: Column(children: items),
    );
  }

  Widget decorateItem(BuildContext context, String no, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              no,
              style: const TextStyle(
                color: Color(0xff252631),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            )
          ),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xff252631),
                fontSize: 14,
              ),
              textAlign: TextAlign.left,
            )
          ),
          SizedBox(
            width: 160,
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xff252631),
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            )
          )
        ],
      )
    );
  }

  List<Widget> decorateBody(BuildContext context) {
    var widgets = <Widget>[];

    widgets.add(const SizedBox(height: 24));

    widgets.add(
      Text(
        "Final Review of your Statements",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      )
    );

    widgets.add(const SizedBox(height: 24));

    widgets.add(decorateScanValues(context));

    widgets.add(const SizedBox(height: 32));

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
    
    widgets.add(const SizedBox(height: 12));
 
    widgets.add(
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: descriptions[1],
          style: const TextStyle(
            color: Color(0xff252631),
            fontSize: 14,
            height: 1.4,
          ),
        )
      )
    );
    
    widgets.add(const SizedBox(height: 12));
 
    widgets.add(
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: descriptions[2],
          style: const TextStyle(
            color: Color(0xff252631),
            fontSize: 14,
            height: 1.4,
          ),
        )
      )
    );

    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
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
              width: 200,
              height: 40,
              child: FotocButton(
                buttonText: "Submit All Statements",
                onPressed: () {
                  onPressedSubmit(context);
                },
              ),
            )
          ]
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
