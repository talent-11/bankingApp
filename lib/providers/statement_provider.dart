import 'package:flutter/cupertino.dart';
import 'package:fotoc/models/statement_model.dart';

class CurrentStatement with ChangeNotifier {
  StatementModel _statement = StatementModel();

  StatementModel get statement => _statement;

  void setStatement(StatementModel statement) {
    _statement = statement;
    notifyListeners();
  }
}
