import 'package:flutter/cupertino.dart';
import 'package:fotoc/models/account_model.dart';

class CurrentAccount with ChangeNotifier {
  late AccountModel _account;
  bool _loggedIn = false;
  late String _fcmToken;

  AccountModel get account => _account;
  bool get loggedIn => _loggedIn;
  String get fcmToken => _fcmToken;

  void login(bool loggedIn) {
    _loggedIn = loggedIn;
    notifyListeners();
  }

  void setAccount(AccountModel account) {
    _account = account;
    notifyListeners();
  }

  void updateAccountBank(double checking) {
    if (!_loggedIn) return;
    _account.bank!.checking = checking;
    notifyListeners();
  }

  void setFcmToken(String fcmToken) {
    _fcmToken = fcmToken;
  }
}
