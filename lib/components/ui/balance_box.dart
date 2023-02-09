import 'package:flutter/material.dart';
import 'package:fotoc/components/wizard/text_with_cc.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/models/account_model.dart';

class BalanceBox extends StatelessWidget {
  const BalanceBox(
    {
      Key? key,
      required this.user,
    }
  ) : super(key: key);
     
  final AccountModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 240,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextWithCC(text: ("{{s}}" + Ext.formatCurrency.format(user.bank!.checking)), fontSize: 20, color: Colors.black, lineHeight: 1.0,),
          const SizedBox(height: 8),
          Text(
            user.verifiedId != null ? "Transactional Account Balance" : "Test Account Balance", 
            style: Theme.of(context).textTheme.headline6,
          )
        ]
      ),
    );
  }
}
