import 'dart:convert';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/models/transaction_model.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/providers/settings_provider.dart';
import 'package:fotoc/providers/transactions_provider.dart';


class AppState {
  bool loading;

  AppState(this.loading);
}

class ScanPayPage extends StatefulWidget {
  const ScanPayPage({Key? key, required this.receiver, required this.receiverType, required this.sender}) : super(key: key);

  final AccountModel receiver;
  final String receiverType;
  final AccountModel sender;

  @override
  State<ScanPayPage> createState() => _ScanPayPageState();
}

class _ScanPayPageState extends State<ScanPayPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _app = AppState(false);
  String _amount = "0.00";

  Future<void> transfer() async {
    if (_app.loading) return;

    bool isBusiness = Provider.of<SettingsProvider>(context, listen: false).bizzAccount == Ext.business;

    setState(() => _app.loading = true);
    String params = jsonEncode(<String, dynamic>{
      'receiver_id': widget.receiver.id,
      'receiver_type': widget.receiverType,
      'sender_id': isBusiness ? widget.sender.business!.id : widget.sender.id,
      'sender_type': isBusiness ? Ext.business : Ext.individual,
      'price': _amount
    });
    Response? response = await ApiService().post(ApiConstants.pay, widget.sender.token, params);
    setState(() => _app.loading = false);

    if (response == null) {
      showDialog(
        context: context, 
        builder: (context) {
          return const ErrorDialog(text: "Please check your network connection");
        }
      );
    } else if (response.statusCode == 200) {
      const snackBar = SnackBar(content: Text('Paid successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      AccountModel me = widget.sender;
      double fee = (widget.receiver.business!.id == widget.sender.id || widget.receiver.id == widget.sender.business!.id) ? 0.2 : 0;
      if (isBusiness) {
        me.business!.bank!.checking -= double.parse(Ext.formatCurrency.format(double.parse(_amount) * (1 + fee)));
      } else {
        me.bank!.checking -= double.parse(Ext.formatCurrency.format(double.parse(_amount) * (1 + fee)));
      }
      context.read<AccountProvider>().setAccount(me);
      
      context.read<TransactionsProvider>().addTransaction(
        TransactionModel(
          name: widget.receiver.name!,
          date: DateFormat('MMM d').format(DateTime.now()),
          amount: _amount,
          paid: true,
          toMe: me.business != null && (me.business!.id == widget.receiver.id || me.id == widget.receiver.id)
        )
      );

      Navigator.pop(context);
    } else if (response.statusCode == 400) {
      showDialog(
        context: context, 
        builder: (context) {
          dynamic res = json.decode(response.body);
          String text = res["message"];
          return ErrorDialog(text: text);
        }
      );
    }
  }

  void onPressedNext(BuildContext context) {
    bool isBusiness = Provider.of<SettingsProvider>(context, listen: false).bizzAccount == Ext.business;
    String error = "";

    if (_amount.isEmpty || double.parse(_amount) == 0) {
      error = 'Please enter amount';
    } else if (double.parse(_amount) > (isBusiness ? widget.sender.business!.bank!.checking : widget.sender.bank!.checking)) {
      error = 'Overflow your balance, currently your balance is {{s}}' + (isBusiness ? widget.sender.business!.bank!.checking.toString() : widget.sender.bank!.checking.toString());
    } else if (double.parse(_amount) < 0) {
      error = 'Can not input negative';
    }

    if (error.isEmpty) {
      transfer();
    } else {
      showDialog(
        context: context, 
        builder: (context) {
          return ErrorDialog(text: error);
        }
      );
    }
  }

  void onPressedCancel(BuildContext context) {
    Navigator.pop(context);
  }

  Widget decorateRow(BuildContext context, Widget w1, Widget w2) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffe8ecef), width: 1.0))
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 24, top: 16, bottom: 8),
        child: Row(
          children: [
            w1,
            const Spacer(flex: 1),
            w2
          ]
        ),
      ),
    );
  }

  Widget decorateStaticValues(BuildContext context, String label, String value) {
    return decorateRow(
      context, 
      Text(label, style: const TextStyle(color: Colors.black54, fontSize: 15)), 
      Text(value, style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold))
    );
  }

  Widget decorateStaticCCValues(BuildContext context, String label, String value) {
    return decorateRow(
      context, 
      Text(label, style: const TextStyle(color: Colors.black54, fontSize: 15)), 
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: SvgPicture.asset(
              "assets/svgs/cc.svg",
              width: 20 * 0.379412,
              height: 20,
              color: Colors.black,
            ),
          ),
          Text(value, style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold))
        ],
      )
    );
  }

  InputDecoration inputDecoration(BuildContext context, {String hintText = ''}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: Theme.of(context).textTheme.bodyText1,
      contentPadding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      // border: const OutlineInputBorder(
      //   borderSide: BorderSide.none,
      // ),
    );
  }

  Widget decorateAmountRow(BuildContext context) {
    return decorateRow(
      context, 
      const Text('Amount to pay', style: TextStyle(color: Colors.black54, fontSize: 15)), 
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0, top: 4.0),
            child: SvgPicture.asset(
              "assets/svgs/cc.svg",
              width: 20 * 0.379412,
              height: 20,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 96,
            height: 24,
            child: TextFormField(
              enabled: !_app.loading,
              textAlign: TextAlign.right,
              decoration: inputDecoration(context),
              keyboardType: TextInputType.number,
              initialValue: _amount,
              onChanged: (val) => setState(() => _amount = val.replaceAll(',', '')),
              inputFormatters: [
                CurrencyTextInputFormatter(
                  decimalDigits: 2,
                  locale: 'en',
                  symbol: '',
                )
              ],
              // validator: (value) {
              //   if (value == null || value.isEmpty || double.parse(value) == 0) {
              //     return 'Please enter amount';
              //   } else if (double.parse(value) < 0) {
              //     return 'Can not input negative';
              //   }
              //   return null;
              // },
            ),
          )
        ]
      )
    );
  }

  List<Widget> decorateForm(BuildContext context) {
    String sg = Ext.formatCurrency.format(double.parse(_amount.isEmpty ? "0" : _amount) * 0.015);
    String cg = Ext.formatCurrency.format(double.parse(_amount.isEmpty ? "0" : _amount) * 0.005);
    String total = Ext.formatCurrency.format(double.parse(_amount.isEmpty ? "0" : _amount) * 1.02);

    var widgets = <Widget>[];
    widgets.add(const LogoBar());
    widgets.add(decorateStaticValues(context, "Pay From", widget.sender.name!));
    widgets.add(decorateStaticValues(context, "Pay To", widget.receiver.name!));
    widgets.add(decorateAmountRow(context));
    widgets.add(decorateStaticCCValues(context, "SG Contribution (1.5%)", sg));
    widgets.add(decorateStaticCCValues(context, "CG Contribution (0.5%)", cg));
    widgets.add(decorateStaticCCValues(context, "Total Amount", total));
    // widgets.add(decoratePasswordRow(context));
    return widgets;
  }

  Widget footer(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 32),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 48,
                child: FotocButton(
                  outline: true,
                  buttonText: "Cancel",
                  onPressed: () {
                    onPressedCancel(context);
                  },
                ),
              )
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 48,
                child: FotocButton(
                  loading: _app.loading,
                  buttonText: "Pay",
                  onPressed: () {
                    onPressedNext(context);
                  },
                ),
              )
            ),
          ]
        ),
      ),
      // const Dots(selectedIndex: 0, dots: 2),
    ],
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: decorateForm(context)
                ),
              )
            )
          ),
          footer(context)
        ]
      ),
    );
  }
}
