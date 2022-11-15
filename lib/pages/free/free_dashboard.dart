import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/components/ui/primary_button.dart';
import 'package:fotoc/components/ui/icon_text_button.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/bullet_row.dart';
import 'package:fotoc/components/wizard/text_with_cc.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/models/transaction_model.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/pages/free/scan_pay.dart';
import 'package:fotoc/pages/qr/show_qr_code.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/pages/free/manual_pay.dart';

class AppState {
  AccountModel me;
  bool loading;

  AppState(this.me, this.loading);
}

final formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "");
// final TRANSACTIONS = [
//   TransactionModel(name: "Jenny Bloye", date: 'Nov 2', amount: "25.00"),
//   TransactionModel(name: "Brad Erickson", date: 'Oct 24', amount: "40.00"),
//   TransactionModel(name: "Rose C", date: 'Oct 18', amount: "8.00"),
// ];

class FreeDashboardPage extends StatefulWidget {
  const FreeDashboardPage({Key? key}) : super(key: key);

  @override
  State<FreeDashboardPage> createState() => _FreeDashboardPageState();
}

class _FreeDashboardPageState extends State<FreeDashboardPage> {
  final app = AppState(AccountModel(), false);
  List<TransactionModel> transactions = [];
  // List<TransactionModel> transactions = TRANSACTIONS;

  @override
  void initState() {
    super.initState();
    
    Future.delayed(const Duration(milliseconds: 10), _getTransactions);
    // _getTransactions();
  }

  _getTransactions() async {
    if (app.loading) return;

    transactions = [];
    setState(() => app.loading = true);
    Response? response = await ApiService().get(ApiConstants.transaction, app.me.token);
    setState(() => app.loading = false);

    if (response != null && response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      for (Map<String, dynamic> trans in data) {
        Map<String, dynamic> sender = trans['sender'];
        Map<String, dynamic> receiver = trans['receiver'];

        transactions.add(
          TransactionModel(
            name: sender['username'] == app.me.username ? receiver['name'] : sender['name'],
            date: DateFormat('MMM d').format(DateTime.parse(trans['created_at'])),
            amount: trans['amount'],
            paid: sender['username'] == app.me.username
          )
        );
      }

      return;
    }

    String errorText = "";
    if (response == null) {
      errorText = "Please check your network connection";
    } else if (response.statusCode == 403) {
      dynamic res = json.decode(response.body);
      errorText = res["detail"];
    }

    showDialog(
      context: context, 
      builder: (context) {
        return ErrorDialog(text: errorText);
      }
    );
  }

  void onPressedGetFullAccount(BuildContext context) {
    Navigator.pushNamed(context, '/free/verify/1');
  }

  void onPressedMore(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context) {
        return const ErrorDialog(
          title: 'Info',
          text: 'Referral program: You will receive {{s}}1000, credited to your account, for everyone who signs up and obtains a fully verified account with FOTOC Bank - using your referral code. Everyone who obtains a fully verified account will receive a referral code that they can give to the people they refer to sign up.'
        );
      }
    );
  }

  void onPressedQrCode(BuildContext context) {
    String params = jsonEncode(<String, dynamic>{
      'id': app.me.id,
      'name': app.me.name
    });
    Navigator.push(context, MaterialPageRoute(builder: (_) => ShowQrCodeScreen(dataString: params)));
  }

  void onPressedPay(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ManualPayPage(buyer: app.me)));
  }

  void onPressedScan(BuildContext context) {
    scan();
  }

  Future scan() async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      dynamic sellerJson = json.decode(barcode.rawContent);
      if (sellerJson.containsKey('id') && sellerJson.containsKey('name')) {
        AccountModel seller = AccountModel(id: int.parse(sellerJson["id"]), name: sellerJson["name"]);

        if (seller.id == app.me.id) {
          showDialog(
            context: context, 
            builder: (context) {
              return const ErrorDialog(text: "You are trying to pay to you.");
            }
          );

          return;
        }
        Navigator.push(context, MaterialPageRoute(builder: (_) => ScanPayPage(seller: seller, buyer: app.me)));
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        // setState(() => barcode = 'The user did not grant the camera permission!');
      } else {
        // setState(() => barcode = 'Unknown error: $e');
      }
    } on FormatException{
      // setState(() => barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      // setState(() => barcode = 'Unknown error: $e');
    }
  }

  Widget decorateTransaction(BuildContext context, TransactionModel transaction) {
    return Row(
      children: [
        Icon(
          Icons.account_circle,
          color: Theme.of(context).primaryColor,
          size: 60.0,
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffe8ecef), width: 1.0))
              ),
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
    }
    return Column(
      children: transactionWidgets
    );
  }

  Widget decorateButtons(BuildContext context) => Row(
    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
        flex: 1,
        child: SizedBox(
          height: 48,
          child: FotocIconTextButton(
            icon: Icon(Icons.qr_code, size: 20, color: Theme.of(context).primaryColor),
            outline: true,
            buttonText: "Scan",
            onPressed: () => onPressedScan(context),
          )
        )
      ),
      const SizedBox(
        width: 16,
      ),
      Expanded(
        flex: 1,
        child: SizedBox(
          height: 48,
          child: FotocIconTextButton(
            icon: SvgPicture.asset("assets/svgs/cc.svg", width: 20 * 0.379412, height: 20, color: Colors.white),
            buttonText: "Pay",
            onPressed: () => onPressedPay(context),
          )
        )
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    AccountModel me = context.watch<CurrentAccount>().account;
    setState(() {
      app.me = me;
    });
    
    return Scaffold(
      body: Column(
        children: [
          const LogoBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: PrimaryButton(
                        buttonText: "Get Full Account", 
                        onPressed: () => onPressedGetFullAccount(context)
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            "Fully Verified Account Holders get:", 
                            style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const BulletRow(text: "Ability to receive {{s}}", color: Color(0xff252631)),
                        const BulletRow(text: "{{s}}10,000.00 to spend or save.", color: Color(0xff252631)),
                        const BulletRow(text: "We match the funds you have in other currency systems.", color: Color(0xff252631)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 200,
                              child: BulletRow(text: "{{s}}1,000 for every referral", color: Color(0xff252631)),
                            ),
                            TextButton(
                              child: Text("(See details)", style: Theme.of(context).textTheme.headline6),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft),
                              onPressed: () => onPressedMore(context)
                            )
                          ]
                        ),
                        const BulletRow(text: "3% interest on savings account", color: Color(0xff252631)),
                        const Divider(height: 16, thickness: 1, color: Colors.black26),
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 24),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                margin: const EdgeInsets.only(right: 16),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(40),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: const Offset(0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.qr_code, size: 48, color: Colors.white),
                                  onPressed: () => onPressedQrCode(context),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    me.name!, 
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor, 
                                      decoration: TextDecoration.underline, 
                                      decorationThickness: 1.5,
                                      fontSize: 18, 
                                      fontWeight: FontWeight.w500
                                    )
                                  ),
                                  Text(
                                    "@" + me.username!,
                                    style: Theme.of(context).textTheme.headline6,
                                  )
                                ],
                              )
                            ]
                          ),
                        ),
                        Center(
                          child: Container(
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
                                TextWithCC(text: ("{{s}}" + formatCurrency.format(me.bank!.checking)), fontSize: 20, color: Colors.black, lineHeight: 1.0,),
                                Text(
                                  "Test Account Balance", 
                                  style: Theme.of(context).textTheme.headline6,
                                )
                              ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: decorateButtons(context),
                        )
                      ],
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: decorateTransactions(context),
                  )
                ]
              ),
            )
          )
        ],
      )
    );
  }
}
