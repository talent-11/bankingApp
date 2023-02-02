import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/pages/wizard/sidebar.dart';

class IndividualAccountPage extends StatefulWidget {
  const IndividualAccountPage({Key? key}) : super(key: key);

  @override
  State<IndividualAccountPage> createState() => _IndividualAccountPageState();
}

class _IndividualAccountPageState extends State<IndividualAccountPage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  void onPressedBar(BuildContext context) {
    _scaffoldState.currentState?.openDrawer();
  }

  IconButton menuButton(BuildContext context) => IconButton(
    icon: const Icon(Icons.menu, size: 32.0),
    onPressed: () => onPressedBar(context), 
    color: Colors.white,
  );

  List<Widget> decorateBody(BuildContext context) {
    List<Widget> widgets = [];

    return widgets;
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: decorateBody(context)
              ),
            )
          )
        ],
      )
    );
  }
}
