import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fotoc/components/ui/transactions_view.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:fotoc/components/ui/icon_button.dart';
import 'package:fotoc/components/ui/search_bar.dart';
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
import 'package:fotoc/pages/wizard/sidebar.dart';

class AppState {
  AccountModel me;
  bool loading;

  AppState(this.me, this.loading);
}

final formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "");

class FreeDashboardPage extends StatefulWidget {
  const FreeDashboardPage({Key? key}) : super(key: key);

  @override
  State<FreeDashboardPage> createState() => _FreeDashboardPageState();
}

class _FreeDashboardPageState extends State<FreeDashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final app = AppState(AccountModel(), false);
  List<TransactionModel> _transactions = [];
  final TextEditingController _controller = TextEditingController();
  String _searchString = "";

  @override
  void initState() {
    super.initState();
    
    // Future.delayed(const Duration(milliseconds: 10), getTransactions);
    getTransactions();
  }

  getTransactions() async {
    if (app.loading) return;

    _transactions = [];
    setState(() => app.loading = true);
    AccountModel me = Provider.of<CurrentAccount>(context, listen: false).account;
    Response? response = await ApiService().get(ApiConstants.transaction, me.token);
    setState(() => app.loading = false);

    if (response != null && response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      for (Map<String, dynamic> trans in data) {
        Map<String, dynamic> sender = trans['sender'];
        Map<String, dynamic> receiver = trans['receiver'];

        _transactions.add(
          TransactionModel(
            name: sender['username'] == me.username ? receiver['name'] : sender['name'],
            date: DateFormat('MMM d').format(DateTime.parse(trans['created_at'])),
            amount: trans['amount'],
            paid: sender['username'] == me.username
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
    Navigator.pushNamed(context, '/free/verify/0');
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
      'name': app.me.name,
      'username': app.me.username,
      'email': app.me.email,
    });
    Navigator.push(context, MaterialPageRoute(builder: (_) => ShowQrCodeScreen(dataString: params)));
  }

  void onPressedPay(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ManualPayPage(buyer: app.me)));
  }

  void onPressedScan(BuildContext context) {
    scan();
  }

  void onPressedBar(BuildContext context) {
    _scaffoldState.currentState?.openDrawer();
  }

  void onPressedHome(BuildContext context) {

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

  IconButton menuButton(BuildContext context) => IconButton(
    icon: const Icon(Icons.menu, size: 32.0),
    onPressed: () => onPressedBar(context), 
    color: Colors.white,
  );

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

  List<Widget> decorateBody(BuildContext context) {
    List<Widget> widgets = [];
    if (app.me.verifiedId != "--") {
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: FotocIconButton(
                  icon: const Icon(Icons.home, color: Colors.white, size: 32.0), 
                  onPressed: () => onPressedHome(context)
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 0, top: 8),
                child: FotocSearchBar(
                  controller: _controller,
                  onPressedClear: () {
                    _controller.text = "";
                    setState(() => _searchString = "");
                  },
                  onChanged: (value) => setState(() => _searchString = value),
                )
              )
            ],
          )
        ),
      );
    } else {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Center(
            child: PrimaryButton(
              buttonText: "Get Full Account", 
              onPressed: () => onPressedGetFullAccount(context)
            )
          ),
        ),
      );

      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
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
            ],
          )
        ),
      );
    }

    widgets.add(
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
                  app.me.name!, 
                  style: TextStyle(
                    color: Theme.of(context).primaryColor, 
                    decoration: TextDecoration.underline, 
                    decorationThickness: 1.5,
                    fontSize: 18, 
                    fontWeight: FontWeight.w500
                  )
                ),
                Text(
                  "@" + app.me.username!,
                  style: Theme.of(context).textTheme.headline6,
                ),
                app.me.verifiedId != "--" ? const SizedBox(height: 2) : const SizedBox(width: 0, height: 0),
                app.me.verifiedId != "--" ? Text("Your referral code is " + app.me.referralId!, style: Theme.of(context).textTheme.headline6) : const SizedBox(width: 0, height: 0),
                app.me.verifiedId != "--" ? const SizedBox(height: 4) : const SizedBox(width: 0, height: 0),
                app.me.verifiedId != "--" ? 
                  const TextWithCC(text: ("Invite friends, earn {{s}}1,000"), fontSize: 14, color: Colors.lightBlue, lineHeight: 1.0) : 
                  const SizedBox(width: 0, height: 0)
              ],
            )
          ]
        ),
      ),
    );

    widgets.add(
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
              TextWithCC(text: ("{{s}}" + formatCurrency.format(app.me.bank!.checking)), fontSize: 20, color: Colors.black, lineHeight: 1.0,),
              const SizedBox(height: 8),
              Text(
                app.me.verifiedId != "--" ? "Transactional Account Balance" : "Test Account Balance", 
                style: Theme.of(context).textTheme.headline6,
              )
            ]
          ),
        ),
      ),
    );

    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 32),
        child: decorateButtons(context),
      )
    );

    widgets.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: TransactionsView(transactions: _transactions),
      )
    );
    
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    AccountModel me = context.watch<CurrentAccount>().account;
    setState(() {
      app.me = me;
    });
    
    return Scaffold(
      key: _scaffoldState,
      drawer: const SideBar(),
      body: Column(
        children: [
          LogoBar(iconButton: menuButton(context)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: decorateBody(context)
              ),
            )
          )
        ],
      )
    );
  }
}
