// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fotoc/pages/bizz/business_account.dart';
import 'package:fotoc/pages/bizz/individual_account.dart';
import 'package:fotoc/pages/settings/settings.dart';
import 'package:provider/provider.dart';
// import 'package:fotoc/constants.dart';
// import 'package:fotoc/pages/statement/statement_Information.dart';
// import 'package:fotoc/services/api_service.dart';
// import 'package:http/http.dart';

import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/pages/free/free_dashboard.dart';
import 'package:fotoc/providers/account_provider.dart';
// import 'package:fotoc/providers/account_provider.dart';


class MainTabsPage extends StatefulWidget {
  const MainTabsPage({Key? key}) : super(key: key);

  @override
  State<MainTabsPage> createState() => _MainTabsPageState();
}

class _MainTabsPageState extends State<MainTabsPage> {
  late AccountModel _me;
  bool _isBizz = true;
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
      // if (_me.verifiedId != "--" && _me.business != null && _selectedIndex == 1 && index == 1) {
      //   _isBizz = !_isBizz;
      // }
      if (_me.verifiedId != "--" && _me.business != null && index == 1) {
        _selectedIndex = 0;
      } else {
        _selectedIndex = index;
      }
    });
  }

  List<Widget> getPages() {
    List<Widget> pages = [];
    pages.add(const FreeDashboardPage());
    // pages.add(_isBizz ? const BusinessAccountPage() : const IndividualAccountPage());
    pages.add(const BusinessAccountPage());
    pages.add(const Icon(Icons.currency_bitcoin, size: 150));
    pages.add(const Icon(Icons.account_balance_wallet, size: 150));
    pages.add(const SettingsPage());

    return pages;
  }

  List<BottomNavigationBarItem> getBottomIcons() {
    List<BottomNavigationBarItem> icons = [];
    icons.add(const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Dashboard"));
    // if (alreadyMatched == false) {
    //   icons.add(const BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: "Match Funds"));
    // }
    // icons.add(
    //   BottomNavigationBarItem(
    //     icon: Icon(_isBizz ? Icons.account_balance : Icons.account_balance_outlined), 
    //     label: _isBizz ? "Bizz-Acct" : "Individual"
    //   )
    // );
    icons.add(const BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: "Bizz-Acct"));
    icons.add(const BottomNavigationBarItem(icon: Icon(Icons.payments), label: "Pay/Request"));
    icons.add(const BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Match Funds"));
    icons.add(const BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: "Me"));
    return icons;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _me = context.watch<CurrentAccount>().account;
    });

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
