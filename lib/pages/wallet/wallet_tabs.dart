import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class WalletTabsPage extends StatefulWidget {
  const WalletTabsPage({Key? key}) : super(key: key);

  @override
  State<WalletTabsPage> createState() => _WalletTabsPageState();
}

class _WalletTabsPageState extends State<WalletTabsPage> {
  int _selectedIndex = 0;

  void onPressedTabItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   child: _pages.elementAt(_selectedIndex), //New
      // ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        decoration: const BoxDecoration(color: Colors.white),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.clock),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.share),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.briefcase),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.calendar),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.bars),
              label: "",
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: onPressedTabItem,
          iconSize: 24,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: const Color(0xff778ca2),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
        ),
      )
    );
  }
}
