import 'package:flutter/material.dart';
import 'package:fotoc/pages/free/free_dashboard.dart';

class MainTabsPage extends StatefulWidget {
  const MainTabsPage({Key? key}) : super(key: key);

  @override
  State<MainTabsPage> createState() => _MainTabsPageState();
}

class _MainTabsPageState extends State<MainTabsPage> {
  int _selectedIndex = 0;

  void onPressedTabItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    FreeDashboardPage(),
    Icon(
      Icons.credit_card,
      size: 150,
    ),
    Icon(
      Icons.payments,
      size: 150,
    ),
    Icon(
      Icons.currency_bitcoin,
      size: 150,
    ),
    Icon(
      Icons.settings,
      size: 150,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: const BoxDecoration(color: Colors.white),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: "Cards",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payments),
              label: "Pay/Request",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_bitcoin),
              label: "Crypto",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            )
          ],
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
