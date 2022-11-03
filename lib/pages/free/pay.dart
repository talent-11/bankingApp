import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:fotoc/providers/account_provider.dart';


class AppState {
  bool loading;

  AppState(this.loading);
}

final formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "");

class PayPage extends StatefulWidget {
  const PayPage({Key? key, required this.seller, required this.buyer}) : super(key: key);

  final AccountModel seller;
  final AccountModel buyer;

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final app = AppState(false);
  String amount = "0.00";

  Future<void> _pay() async {
    if (app.loading) return;

    setState(() => app.loading = true);
    String params = jsonEncode(<String, dynamic>{
      'seller': widget.seller.id,
      'price': amount
    });
    Response? response = await ApiService().post(ApiConstants.pay, widget.buyer.token, params);
    setState(() => app.loading = false);
    // Navigator.pushNamed(context, '/free/verify/2');

    if (response == null) {
      showDialog(
        context: context, 
        builder: (context) {
          return const ErrorDialog(text: "Please check your network connection");
        }
      );
    } else if (response.statusCode == 200) {
      const snackBar = SnackBar(
        content: Text('Paid successfully'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      AccountModel me = widget.buyer;
      me.bank!.checking -= double.parse(formatCurrency.format(double.parse(amount) * 1.02));
      context.read<CurrentAccount>().changeAccount(me);

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
    String error = "";

    if (amount.isEmpty || double.parse(amount) == 0) {
      error = 'Please enter amount';
    } else if (double.parse(amount) < 0) {
      error = 'Can not input negative';
    }

    if (error.isEmpty) {
      _pay();
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
              enabled: !app.loading,
              textAlign: TextAlign.right,
              decoration: inputDecoration(context),
              keyboardType: TextInputType.number,
              initialValue: amount,
              onChanged: (val) => setState(() => amount = val),
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
    String sg = formatCurrency.format(double.parse(amount.isEmpty ? "0" : amount) * 0.015);
    String cg = formatCurrency.format(double.parse(amount.isEmpty ? "0" : amount) * 0.005);
    String total = formatCurrency.format(double.parse(amount.isEmpty ? "0" : amount) * 1.02);

    var widgets = <Widget>[];
    widgets.add(const LogoBar());
    widgets.add(decorateStaticValues(context, "Pay From", widget.buyer.name!));
    widgets.add(decorateStaticValues(context, "Pay To", widget.seller.name!));
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
                  loading: app.loading,
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
