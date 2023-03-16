import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/models/statement_model.dart';
import 'package:fotoc/pages/statement/statement_final.dart';
import 'package:fotoc/pages/statement/statement_scan.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/providers/statement_provider.dart';
import 'package:fotoc/services/api_service.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart';

const descriptions = [
  "We will one-time match checking accounts, savings accounts, retirement accounts, investment accounts (stocks, bonds, mutual funds, Insurance policies with a statement of cash value, CDs, options, futures, and ETFs) and crypto currency accounts.",
  "By Submitting your document and this form you attest to the truth and accuracy of it and agree to be bound by the laws of the Constitutional Government for the United States of America"
];

const errors = [
  "Fields must match your scanned statement.",
  "Information on Statement for Acct Holder must match with information on Individual Acct Holder at FOTOC Bank"
];

class StatementPreviewPage extends StatefulWidget {
  const StatementPreviewPage({Key? key}) : super(key: key);

  @override
  State<StatementPreviewPage> createState() => _StatementPreviewPageState();
}

class _StatementPreviewPageState extends State<StatementPreviewPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AccountModel? _me;
  StatementModel? _statement;
  String _year = "";
  double _balance = 0;
  List<dynamic> _errors = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    AccountModel me = Provider.of<AccountProvider>(context, listen: false).account;
    StatementModel statement = Provider.of<StatementProvider>(context, listen: false).currentStatement;
    setState(() { _me = me; _statement = statement; });
    
    Future.delayed(const Duration(milliseconds: 10), _getOcrData);
  }

  void _getOcrData() async {
    setState(() { _loading = true; _errors = []; });

    String filename = Provider.of<AccountProvider>(context, listen: false).uploadedFilename;

    String params = jsonEncode(<String, dynamic>{ 
      'file': filename, 
      'year': _statement!.year!.toString(), 
      'bank': _statement!.bankName!,
      'name': _statement!.name!,
      'balance': Ext.formatCurrency.format(_statement!.balance!)
    });

    Response? response = await ApiService().post(ApiConstants.ocrStatement, _me?.token, params);
    setState(() {
      _loading = false;
    });

    if (response == null) {
      return;
    }
    
    dynamic res = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() { _errors = res["error_types"]; });
    } else if (response.statusCode == 400) {
    }
  }

  void onPressedAnother(BuildContext context) {
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count ++ == 4;
    });
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

    if (_errors.contains("bank")) {
      items.add(decorateItem(context, "Bank", "Wrong bank name", color: Colors.redAccent));
    } else {
      items.add(decorateItem(context, "Bank", _statement!.bankName!));
    }

    if (_errors.contains("name")) {
      items.add(decorateItem(context, "Account Name", "Wrong name", color: Colors.redAccent));
    } else {
      items.add(decorateItem(context, "Account Name", _statement!.name!));
    }

    if (_errors.contains("address")) {
      items.add(decorateItem(context, "Address Line 1", "Wrong address", color: Colors.redAccent));
      items.add(decorateItem(context, "Address Line 2", "Wrong address", color: Colors.redAccent));
      items.add(decorateItem(context, "Address Line 3", "Wrong address", color: Colors.redAccent));
    } else {
      items.add(decorateItem(context, "Address Line 1", _me!.suite!));
      items.add(decorateItem(context, "Address Line 2", _me!.city! + ", " + _me!.state! + " " + _me!.zipcode!));
      items.add(decorateItem(context, "Address Line 3", ""));
    }

    if (_errors.contains("balance")) {
      items.add(decorateItem(context, "Statement Balance", "Wrong balance", color: Colors.redAccent));
    } else {
      items.add(decorateItem(context, "Statement Balance", "\$" + Ext.formatCurrency.format(_statement!.balance!)));
    }

    if (_errors.contains("year")) {
      items.add(decorateItem(context, "Statement Year", "Old statement", color: Colors.redAccent));
    } else {
      items.add(decorateItem(context, "Statement Year", _statement!.year!.toString()));
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

    items.add(decorateItem(context, "Acct Holder", _statement!.name!));
    items.add(decorateItem(context, "Address Line 1", _me!.suite!));
    items.add(decorateItem(context, "Address Line 2", _me!.city! + ", " + _me!.state! + " " + _me!.zipcode!));
    items.add(decorateItem(context, "Address Line 3", ""));

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12)
      ),
      child: Column(children: items),
    );
  }

  Widget decorateItem(BuildContext context, String label, String value, {Color? color = const Color(0xff98a9bc)}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 132,
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
            style: TextStyle(
              color: color,
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
