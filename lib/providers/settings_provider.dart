import 'package:flutter/cupertino.dart';
import 'package:fotoc/constants.dart';

class SettingsProvider with ChangeNotifier {
  String _bizzAccount = Ext.individual;
  int _selectedTabIndex = 0;

  String get bizzAccount => _bizzAccount;
  int get selectedTabIndex => _selectedTabIndex;

  void setBizzAccount(String bizzAccount) {
    _bizzAccount = bizzAccount;
    notifyListeners();
  }

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }
}
