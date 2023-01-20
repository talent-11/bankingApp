import 'dart:convert';
import 'dart:io';

import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/pages/statement/statement_Information.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/services/api_service.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class AppState {
  AccountModel me;

  AppState(this.me);
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final app = AppState(AccountModel());
  bool alreadyMatched = false;

  @override
  void initState() {
    super.initState();
    
    Future.delayed(const Duration(milliseconds: 10), _getStatements);
  }

  void _getStatements() async {
    Response? response = await ApiService().get(ApiConstants.statement, app.me.token);

    if (response != null && response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        setState(() {
          alreadyMatched = true;
        });
      }
    }
  }

  void onPressedMatch(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const StatementInformationPage()));
  }

  void onPressedLogout(BuildContext context) {
    exit(0);
  }

  void onPressedUpload(BuildContext context) {
    
  }

  Widget decorateMenuItem(BuildContext context, String menuText, Function onPressed) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
        color: const Color(0xff5d10f6).withOpacity(0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              menuText,
              style: const TextStyle(
                color: Color(0xff252631),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ]
        ),
      )
    );
  }
  
  List<Widget> decorateBody(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(const LogoBar());
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 32, bottom: 4), 
        child: SizedBox(
          width: 92,
          height: 92,
          child: Image.asset("assets/images/profile_men.png")
        )
      )
    );
    widgets.add(Text(app.me.name!, style: Theme.of(context).textTheme.headline1));
    widgets.add(const SizedBox(height: 32));
    if (alreadyMatched == false) {
      widgets.add(decorateMenuItem(context, "Match Funds", () {onPressedMatch(context);}));
      widgets.add(const SizedBox(height: 1));
    }
    widgets.add(decorateMenuItem(context, "Exit", () {onPressedLogout(context);}));
    widgets.add(const SizedBox(height: 1));

    return widgets;
  }
  
  @override
  Widget build(BuildContext context) {
    setState(() {
      app.me = context.watch<CurrentAccount>().account;
    });

    return Scaffold(
      body: Column(
        children: decorateBody(context),
      ),
    );
  }
}
