import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/pages/business/business_verify_0.dart';
import 'package:provider/provider.dart';

import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/pages/wizard/sidebar.dart';

class BusinessAccountPage extends StatefulWidget {
  const BusinessAccountPage({Key? key}) : super(key: key);

  @override
  State<BusinessAccountPage> createState() => _BusinessAccountPageState();
}

class _BusinessAccountPageState extends State<BusinessAccountPage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  late AccountModel _me;

  @override
  void initState() {
    super.initState();

    _me = Provider.of<CurrentAccount>(context, listen: false).account;
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

        ]
      ),
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
              (_me.verifiedId != "--" ? decorateCreateBusiness(context) : decorateVerify(context)) : 
              decorateBody(context)
          )
        ],
      )
    );
  }
}
