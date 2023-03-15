import 'package:flutter/material.dart';
import 'package:fotoc/components/wizard/text_with_cc.dart';
import 'package:fotoc/models/transaction_model.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView(
    {
      Key? key,
      required this.transactions
    }
  ) : super(key: key);
     
  final List<TransactionModel> transactions;

  Widget decorateTransaction(BuildContext context, TransactionModel transaction) {
    return Row(
      children: [
        Icon(Icons.account_circle, color: Theme.of(context).primaryColor, size: 60.0),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffe8ecef), width: 1.0))),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(transaction.name, style: Theme.of(context).textTheme.headline2),
                        Text(transaction.date, style: Theme.of(context).textTheme.bodyText1)
                      ],
                    )
                  ),
                  TextWithCC(
                    text: (transaction.paid ? "-" : "+") + "{{s}}" + transaction.amount, 
                    fontSize: 16.0, 
                    color: transaction.paid ? const Color(0xffdc2f38) : Colors.green, 
                    fontWeight: FontWeight.w400
                  )
                ]
              )
            )
          )
        ),
      ],
    );
  }

  Widget decorateTransactions(BuildContext context) {
    List<Widget> transactionWidgets = [];
    for (var transaction in transactions) {
      transactionWidgets.add(decorateTransaction(context, transaction));
      if (transaction.paid && !transaction.toMe) {
        double amount = double.parse(transaction.amount) * 0.02;
        TransactionModel t = TransactionModel(name: "Contribution", date: transaction.date, amount: amount.toStringAsFixed(2), paid: true, toMe: false);
        transactionWidgets.add(decorateTransaction(context, t));
      }
    }
    return Column(
      children: transactionWidgets
    );
  }

  @override
  Widget build(BuildContext context) {
    return decorateTransactions(context);
  }
}
