import 'package:flutter/cupertino.dart';
import 'package:fotoc/models/account_model.dart';

class CurrentAccount with ChangeNotifier {
  late AccountModel _account;

  AccountModel get account => _account;

  void setAccount(AccountModel account) {
    _account = account;
    notifyListeners();
  }

  void changeAccount(AccountModel account) {
    _account = account;
    notifyListeners();
  }
}
