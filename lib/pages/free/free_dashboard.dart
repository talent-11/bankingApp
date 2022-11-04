import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/components/ui/primary_button.dart';
import 'package:fotoc/components/ui/icon_text_button.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/bullet_row.dart';
import 'package:fotoc/components/wizard/text_with_cc.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/pages/free/people.dart';
import 'package:fotoc/pages/free/scan_pay.dart';
import 'package:fotoc/pages/qr/show_qr_code.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/pages/free/manual_pay.dart';

class AppState {
  AccountModel me;

  AppState(this.me);
}

final formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "");

class FreeDashboardPage extends StatefulWidget {
  const FreeDashboardPage({Key? key}) : super(key: key);

  @override
  State<FreeDashboardPage> createState() => _FreeDashboardPageState();
}

class _FreeDashboardPageState extends State<FreeDashboardPage> {
  final app = AppState(AccountModel());

  void onPressedGetFullAccount(BuildContext context) {
    Navigator.pushNamed(context, '/free/verify/1');
  }

  void onPressedMore(BuildContext context) {
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

  Widget buttons(BuildContext context) => Row(
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
            icon: SvgPicture.asset(
              "assets/svgs/cc.svg",
              width: 20 * 0.379412,
              height: 20,
              color: Colors.white,
            ),
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                const BulletRow(text: "{{s}}10,000.00 to spend or save.", color: Color(0xff252631)),
                const BulletRow(text: "We match the funds you have in other currency systems.", color: Color(0xff252631)),
                const BulletRow(text: "5% Cash Back on all transactions.", color: Color(0xff252631)),
                const BulletRow(text: "U.S.A. Senior Citizens will receive {{s}}3,000 per month", color: Color(0xff252631)),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => onPressedMore(context),
                    child: Text("+ More", style: Theme.of(context).textTheme.headline6)
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Colors.black26),
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
                  child: buttons(context),
                )
              ],
            )
          )
        ],
      )
    );
  }
}
