import 'package:flutter/cupertino.dart';
import 'package:fotoc/models/statement_model.dart';

class StatementProvider with ChangeNotifier {
  List<StatementModel> _statements = [];

  List<StatementModel> get statements => _statements;
  StatementModel get currentStatement => _statements.last;

  void addStatement(StatementModel statement) {
    _statements.add(statement);
    notifyListeners();
  }

  void removeStatements() {
    _statements = [];
    notifyListeners();
  }
}
