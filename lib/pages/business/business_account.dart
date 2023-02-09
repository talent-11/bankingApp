import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/radio_text.dart';
import 'package:fotoc/providers/settings_provider.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/pages/wizard/sidebar.dart';
import 'package:fotoc/pages/business/business_verify_0.dart';
import 'package:fotoc/services/api_service.dart';

class BusinessAccountPage extends StatefulWidget {
  const BusinessAccountPage({Key? key}) : super(key: key);

  @override
  State<BusinessAccountPage> createState() => _BusinessAccountPageState();
}

class _BusinessAccountPageState extends State<BusinessAccountPage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  late AccountModel _me;
  bool _loading = false;
  late String _bizzAccount;

  @override
  void initState() {
    super.initState();

    _me = Provider.of<AccountProvider>(context, listen: false).account;
  }

  void onPressedBar(BuildContext context) {
    _scaffoldState.currentState?.openDrawer();
  }

  void onPressedBusiness(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const BusinessVerify0Page()));
  }

  void onPressedVerified(BuildContext context) {
    Navigator.pushNamed(context, '/free/verify/0');
  }

  void onPressedResend(BuildContext context) async {
    if (_loading) return;

    String token = Provider.of<AccountProvider>(context, listen: false).account.token!;
    String params = jsonEncode(<String, dynamic>{ 'email': _me.business!.email });

    setState(() { _loading = true; });
    Response? response = await ApiService().post(ApiConstants.businessReVerify, token, params);
    setState(() { _loading = false; });

    if (response == null) {
      showDialog(
        context: context, 
        builder: (context) {
          return const ErrorDialog(text: "Please check your network connection");
        }
      );
    } else if (response.statusCode == 200) {
      const snackBar = SnackBar(content: Text('We\'ve just sent a verification email'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (response.statusCode == 400) {
      showDialog(
        context: context, 
        builder: (context) {
          dynamic res = json.decode(response.body);
          String text = res["message"];
          return ErrorDialog(text: text);
        }
      );
    }
  }

  void onPressedRefresh(BuildContext context) async {
    if (_loading) return;

    String token = Provider.of<AccountProvider>(context, listen: false).account.token!;

    setState(() { _loading = true; });
    Response? response = await ApiService().get(ApiConstants.me, token);
    setState(() { _loading = false; });

    if (response == null) {
      showDialog(
        context: context, 
        builder: (context) {
          return const ErrorDialog(text: "Please check your network connection");
        }
      );
    } else if (response.statusCode == 200) {
      dynamic result = json.decode(response.body);
      AccountModel user = AccountModel.fromJson(result['me']);
      user.token = token;
      context.read<AccountProvider>().setAccount(user);
    } else if (response.statusCode == 400) {
      showDialog(
        context: context, 
        builder: (context) {
          dynamic res = json.decode(response.body);
          String text = res["message"];
          return ErrorDialog(text: text);
        }
      );
    }
  }

  IconButton menuButton(BuildContext context) => IconButton(
    icon: const Icon(Icons.menu, size: 32.0),
    onPressed: () => onPressedBar(context), 
    color: Colors.white,
  );

  Widget decorateVerify(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), 
          child: Text(
            "Please sign up for a verified individual account first.",
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          )
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: 200,
          height: 40,
          child: FotocButton(
            buttonText: "Get Full Account", 
            onPressed: () => onPressedVerified(context)
          ),
        )
      ]
    );
  }

  Widget decorateVerifyBusiness(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), 
          child: Text(
            "We've sent a verification email to " + _me.business!.email.toString() + ".\nPlease verify your business email.",
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          )
        ),
        const SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), 
          child: Text(
            "I have verified already.",
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          )
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 160,
          height: 40,
          child: FotocButton(
            buttonText: "Refresh", 
            onPressed: () => onPressedRefresh(context)
          ),
        ),
        const SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), 
          child: Text(
            "I haven't received an email.",
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          )
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 160,
          height: 40,
          child: FotocButton(
            outline: true,
            buttonText: "Resend", 
            onPressed: () => onPressedResend(context)
          ),
        )
      ]
    );
  }

  Widget decorateCreateBusiness(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Please sign up for a business account first.",
          style: Theme.of(context).textTheme.headline2,
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: 200,
          height: 40,
          child: FotocButton(
            buttonText: "Get a Business Account", 
            onPressed: () => onPressedBusiness(context)
          ),
        )
      ]
    );
  }

  Widget decorateBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Please choose your account type.",
          style: Theme.of(context).textTheme.headline1,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(64, 32, 0, 0),
          child: RadioText(
            label: Ext.individual, 
            groupValue: context.watch<SettingsProvider>().bizzAccount, 
            onChanged: (value) {
              context.read<SettingsProvider>().setBizzAccount(value);
            }
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(64, 0, 0, 0),
          child: RadioText(
            label: Ext.business, 
            groupValue: context.watch<SettingsProvider>().bizzAccount, 
            onChanged: (value) {
              context.read<SettingsProvider>().setBizzAccount(value);
            }
          ),
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key: _scaffoldState,
      drawer: const SideBar(),
      body: Column(
        children: [
          LogoBar(iconButton: menuButton(context)),
          Expanded(
            child: _me.business == null ? 
              _me.verifiedId != null ? 
                decorateCreateBusiness(context) : 
                decorateVerify(context) : 
              _me.business!.verified == true ?
                decorateBody(context) :
                decorateVerifyBusiness(context)
          )
        ],
      )
    );
  }
}
