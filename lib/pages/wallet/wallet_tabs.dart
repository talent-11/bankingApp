// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fotoc/constants.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/providers/settings_provider.dart';
import 'package:fotoc/pages/dashboard/manual_pay.dart';
import 'package:fotoc/pages/dashboard/dashboard.dart';
import 'package:fotoc/pages/business/account_switch.dart';
import 'package:fotoc/pages/settings/settings.dart';
import 'package:fotoc/pages/statement/statement_information.dart';
import 'package:fotoc/pages/statement/statement_already.dart';


class MainTabsPage extends StatefulWidget {
  const MainTabsPage({Key? key}) : super(key: key);

  @override
  State<MainTabsPage> createState() => _MainTabsPageState();
}

class _MainTabsPageState extends State<MainTabsPage> {
  // int _selectedIndex = 0;
  // bool _isBizz = true;
  late AccountModel _me;

  @override
  void initState() {
    super.initState();
    
    setState(() {
      _me = Provider.of<AccountProvider>(context, listen: false).account;
    });
  }

  void onPressedTabItem(int index) {
    setState(() {
      // if (_me.verifiedId != null && _me.business != null && _selectedIndex == 1 && index == 1) {
      //   _isBizz = !_isBizz;
      // }
      // if (_me.verifiedId != null && _me.business != null && index == 1) {
      //   _selectedIndex = 0;
      // } else {
        // _selectedIndex = index;
      // }
    });
    context.read<SettingsProvider>().setTabIndex(index);
  }

  List<Widget> getPages() {
    List<Widget> pages = [];

    pages.add(const DashboardPage());
    pages.add(const AccountSwitchPage());
    pages.add(const ManualPayPage());

    bool isBusiness = Provider.of<SettingsProvider>(context, listen: false).bizzAccount == Ext.business;
    bool matched = isBusiness ? _me.business!.fundMatched! : _me.fundMatched!;
    pages.add(matched ? const StatementAlreadyPage() : const StatementInformationPage(from: 'tab'));
    
    pages.add(const SettingsPage());

    return pages;
  }

  List<BottomNavigationBarItem> getBottomIcons() {
    List<BottomNavigationBarItem> icons = [];
    icons.add(const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Dashboard"));
    icons.add(
      BottomNavigationBarItem(
        icon: Icon(context.watch<SettingsProvider>().bizzAccount == Ext.individual ? Icons.account_balance : Icons.account_balance_outlined), 
        label: context.watch<SettingsProvider>().bizzAccount == Ext.individual ? "Bizz-Acct" : Ext.individual
      )
    );
    icons.add(const BottomNavigationBarItem(icon: Icon(Icons.payments), label: "Pay/Request"));
    icons.add(const BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Match Funds"));
    icons.add(const BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: "Me"));
    return icons;
  }

  @override
  Widget build(BuildContext context) {
    int selectedTabIndex = Provider.of<SettingsProvider>(context, listen: false).selectedTabIndex;

    return Scaffold(
      body: Center(child: getPages().elementAt(selectedTabIndex)),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: const BoxDecoration(color: Colors.white),
        child: BottomNavigationBar(
          items: getBottomIcons(),
          currentIndex: selectedTabIndex,
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
