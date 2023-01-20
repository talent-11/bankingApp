import 'package:flutter/cupertino.dart';
import 'package:fotoc/models/account_model.dart';

class CurrentAccount with ChangeNotifier {
  AccountModel _account = AccountModel();
  bool _loggedIn = false;
  late String _fcmToken;
  late String _uploadedFilename;

  AccountModel get account => _account;
  bool get loggedIn => _loggedIn;
  String get fcmToken => _fcmToken;
  String get uploadedFilename => _uploadedFilename;

  void login(bool loggedIn) {
    _loggedIn = loggedIn;
    notifyListeners();
  }

  void setAccount(AccountModel account) {
    String? token = _account.token;
    _account = account;
    if (account.token == null) {
      _account.token = token;
    }
    notifyListeners();
  }

  void setAccountToken(String token) {
    _account.token = token;
    notifyListeners();
  }

  void updateAccountBank(double checking) {
    if (!_loggedIn) return;
    _account.bank!.checking = checking;
    notifyListeners();
  }

  void setFcmToken(String fcmToken) {
    _fcmToken = fcmToken;
    notifyListeners();
  }

  void setUploadedFilename(String filename) {
    _uploadedFilename = filename;
    notifyListeners();
  }
}
