import 'dart:convert';
import 'dart:io';

import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/pages/settings/business_profile.dart';
import 'package:fotoc/pages/settings/individual_profile.dart';
import 'package:fotoc/pages/settings/password_change.dart';
import 'package:fotoc/pages/statement/statement_Information.dart';
import 'package:fotoc/pages/wizard/login.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/providers/settings_provider.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:fotoc/pages/wizard/sidebar.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  late AccountModel _me;
  late bool _isBizzAccount;
  // bool _alreadyMatched = false;

  @override
  void initState() {
    super.initState();
    
    setState(() {
      _me = Provider.of<AccountProvider>(context, listen: false).account;
      _isBizzAccount = Provider.of<SettingsProvider>(context, listen: false).bizzAccount == Ext.business;
    });
    // Future.delayed(const Duration(milliseconds: 10), _getStatements);
  }

  canCloseAccount(Bank bank) {
    return bank.checking <= 0 && bank.saving <= 0;
  }

  // void _getStatements() async {
  //   Response? response = await ApiService().get(ApiConstants.statement, _me.token);
  //   if (response != null && response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body);
  //     if (data.isNotEmpty) {
  //       setState(() {
  //         _alreadyMatched = true;
  //       });
  //     }
  //   }
  // }

  // void onPressedMatch(BuildContext context) {
  //   Navigator.push(context, MaterialPageRoute(builder: (_) => const StatementInformationPage()));
  // }

  void onPressedUpdateProfile(BuildContext context) {
    if (_isBizzAccount) {

    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => _isBizzAccount ? const BusinessProfilePage() : const IndividualProfilePage()));
  }

  void onPressedChangePassword(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const PasswordChangePage()));
  }

  void onPressedCloseAccount(BuildContext context) {
    if (!canCloseAccount(_me.bank!)) {
      showDialog(
        context: context, 
        builder: (context) {
          String text = "Can not close your account because you have some money in your account";
          return ErrorDialog(text: text);
        }
      );
      return;
    }
  }

  void onPressedCloseBusinessAccount(BuildContext context) {
    if (!canCloseAccount(_me.business!.bank!)) {
      showDialog(
        context: context, 
        builder: (context) {
          String text = "Can not close your account because you have some money in your business account";
          return ErrorDialog(text: text);
        }
      );
      return;
    }
  }

  void onPressedLogout(BuildContext context) {
    context.read<AccountProvider>().setAccount(AccountModel());
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
  }

  void onPressedBar(BuildContext context) {
    _scaffoldState.currentState?.openDrawer();
  }

  IconButton menuButton(BuildContext context) => IconButton(
    icon: const Icon(Icons.menu, size: 32.0),
    onPressed: () => onPressedBar(context), 
    color: Colors.white,
  );

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
    widgets.add(LogoBar(iconButton: menuButton(context)));
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 32, bottom: 4), 
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.4), width: 4)
          ),
          child: _isBizzAccount ? 
            Image.asset("assets/images/profile_business.png") : 
            _me.gender == Ext.male ?
              Image.asset("assets/images/profile_men.png") :
              Image.asset("assets/images/profile_women.png")
        )
      )
    );
    widgets.add(Text(_isBizzAccount ? _me.business!.name! : _me.name!, style: Theme.of(context).textTheme.headline1));
    widgets.add(const SizedBox(height: 32));
    // if (_alreadyMatched == false) {
    //   widgets.add(decorateMenuItem(context, "Match Funds", () {onPressedMatch(context);}));
    //   widgets.add(const SizedBox(height: 1));
    // }
    widgets.add(decorateMenuItem(context, "Update Profile", () { onPressedUpdateProfile(context); }));
    widgets.add(const SizedBox(height: 1));
    if (!_isBizzAccount) {
      widgets.add(decorateMenuItem(context, "Change Password", () { onPressedChangePassword(context); }));
      widgets.add(const SizedBox(height: 1));
      widgets.add(decorateMenuItem(context, "Close account", () { onPressedCloseAccount(context); }));
      widgets.add(const SizedBox(height: 1));
    } else {
      widgets.add(decorateMenuItem(context, "Close business account", () { onPressedCloseBusinessAccount(context); }));
      widgets.add(const SizedBox(height: 1));
    }
    widgets.add(decorateMenuItem(context, "Logout", () { onPressedLogout(context); }));

    return widgets;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      drawer: const SideBar(),
      body: Column(
        children: decorateBody(context),
      ),
    );
  }
}
