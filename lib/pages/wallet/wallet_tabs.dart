// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fotoc/pages/settings/settings.dart';
// import 'package:fotoc/constants.dart';
// import 'package:fotoc/pages/statement/statement_Information.dart';
// import 'package:fotoc/services/api_service.dart';
// import 'package:http/http.dart';
// import 'package:provider/provider.dart';

import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/pages/free/free_dashboard.dart';
// import 'package:fotoc/providers/account_provider.dart';

class AppState {
  AccountModel me;

  AppState(this.me);
}

class MainTabsPage extends StatefulWidget {
  const MainTabsPage({Key? key}) : super(key: key);

  @override
  State<MainTabsPage> createState() => _MainTabsPageState();
}

class _MainTabsPageState extends State<MainTabsPage> {
  final app = AppState(AccountModel());
  int _selectedIndex = 0;
  // bool alreadyMatched = false;

  // @override
  // void initState() {
  //   super.initState();
    
  //   Future.delayed(const Duration(milliseconds: 10), _getStatements);
  // }

  // _getStatements() async {
  //   Response? response = await ApiService().get(ApiConstants.statement, app.me.token);

  //   if (response != null && response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body);
  //     if (data.isNotEmpty) {
  //       setState(() {
  //         alreadyMatched = true;
  //       });
  //     }
  //   }
  // }

  void onPressedTabItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> getPages() {
    List<Widget> pages = [];
    pages.add(const FreeDashboardPage());
    // if (alreadyMatched == false) {
    //   pages.add(const StatementInformationPage());
    // }
    pages.add(const Icon(Icons.payments, size: 150));
    pages.add(const Icon(Icons.currency_bitcoin, size: 150));
    pages.add(const SettingsPage());

    return pages;
  }

  List<BottomNavigationBarItem> getBottomIcons() {
    List<BottomNavigationBarItem> icons = [];
    icons.add(const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"));
    // if (alreadyMatched == false) {
    //   icons.add(const BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: "Match Funds"));
    // }
    icons.add(const BottomNavigationBarItem(icon: Icon(Icons.payments), label: "Pay/Request"));
    icons.add(const BottomNavigationBarItem(icon: Icon(Icons.currency_bitcoin), label: "Crypto"));
    icons.add(const BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"));
    return icons;
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   app.me = context.watch<CurrentAccount>().account;
    // });

    return Scaffold(
      body: Center(
        child: getPages().elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: const BoxDecoration(color: Colors.white),
        child: BottomNavigationBar(
          items: getBottomIcons(),
          currentIndex: _selectedIndex,
          onTap: onPressedTabItem,
          iconSize: 24,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: const Color(0xff778ca2),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      )
    );
  }
}
