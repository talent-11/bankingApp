import 'package:flutter/cupertino.dart';
import 'package:fotoc/constants.dart';

class SettingsProvider with ChangeNotifier {
  String _bizzAccount = Ext.individual;

  String get bizzAccount => _bizzAccount;

  void setBizzAccount(String bizzAccount) {
    _bizzAccount = bizzAccount;
    notifyListeners();
  }
}
