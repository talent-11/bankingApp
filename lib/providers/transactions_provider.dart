import 'package:flutter/cupertino.dart';
import 'package:fotoc/models/transaction_model.dart';

class TransactionsProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  void setTransactions(List<TransactionModel> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  void removeAllTransactions() {
    _transactions = [];
    notifyListeners();
  }

  void addTransaction(TransactionModel transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }
}
