import 'package:flutter/cupertino.dart';
import 'package:fotoc/models/account_model.dart';

enum AuthState{ LOGGED_IN, LOGGED_OUT }

class CurrentAccount with ChangeNotifier {
  late AccountModel _account;
  late AuthState _status;

  AccountModel get account => _account;

  void login() {
    _status = AuthState.LOGGED_IN;
    notifyListeners();
  }

  void logout() {
    _status = AuthState.LOGGED_OUT;
    notifyListeners();
  }

  void changeAccount(AccountModel account) {
    _account = account;
    notifyListeners();
  }
}
