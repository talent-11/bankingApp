import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';
import 'package:fotoc/models/statement_model.dart';
import 'package:fotoc/pages/statement/statement_scan.dart';
import 'package:fotoc/providers/statement_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


const description = "Before you begin, make sure you have one monthly statement for every account that you want matched. You will not be able to com back and upload monthly statements a second time. We only match funds one time! Once you upload all your statements and submit, your one time matching is complete!";

class StatementNotifyPage extends StatefulWidget {
  const StatementNotifyPage({Key? key}) : super(key: key);

  @override
  State<StatementNotifyPage> createState() => _StatementNotifyPageState();
}

class _StatementNotifyPageState extends State<StatementNotifyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _bankName, _name;
  late double _balance;
  late int _year;

  void onPressedContinue(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<StatementProvider>().setStatement(StatementModel(name: _name, bankName: _bankName, balance: _balance, year: _year));
      Navigator.push(context, MaterialPageRoute(builder: (_) => const StatementScanPage()));
    }
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
        padding: const EdgeInsets.only(top: 0, bottom: 16),
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
        padding: const EdgeInsets.only(top: 0.0),
        child: TextInputField(
          keyboardType: TextInputType.name,
          hintText: "Enter Bank Name",
          onChanged: (val) {
            setState(() => _bankName = val!);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter bank name';
            }
            return null;
          },
        )
      )
    );
    
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: TextInputField(
          keyboardType: TextInputType.name,
          hintText: "Enter You Full Name in Statement",
          onChanged: (val) {
            setState(() => _name = val!);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
        )
      )
    );
    
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: TextInputField(
          keyboardType: TextInputType.number,
          hintText: "Enter You Ending Balance",
          onChanged: (val) {
            setState(() => _balance = double.parse(val!));
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your ending balance';
            }
            return null;
          },
        )
      )
    );
    
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: TextInputField(
          keyboardType: TextInputType.number,
          hintText: "Enter Statement Year",
          onChanged: (val) {
            setState(() => _year = int.parse(val!));
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your statement year';
            }
            if (int.parse(value) < 2019 || int.parse(value) > 2023)
            {
              return 'Please input lateset statement year';
            }
            return null;
          },
        )
      )
    );
    
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 20),
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
