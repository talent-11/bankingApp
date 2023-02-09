import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:fotoc/components/ui/transactions_view.dart';
import 'package:fotoc/components/ui/thumbnail_bar.dart';
import 'package:fotoc/components/ui/balance_box.dart';
import 'package:fotoc/components/ui/icon_button.dart';
import 'package:fotoc/components/ui/search_bar.dart';
import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/components/ui/primary_button.dart';
import 'package:fotoc/components/ui/icon_text_button.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/bullet_row.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/models/transaction_model.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/pages/dashboard/scan_pay.dart';
import 'package:fotoc/pages/dashboard/show_qr_code.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/pages/dashboard/manual_pay.dart';
import 'package:fotoc/pages/wizard/sidebar.dart';

class AppState {
  AccountModel me;
  bool loading;

  AppState(this.me, this.loading);
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final _app = AppState(AccountModel(), false);
  List<TransactionModel> _transactions = [];
  final TextEditingController _controller = TextEditingController();
  String _searchString = "";

  @override
  void initState() {
    super.initState();
    
    // Future.delayed(const Duration(milliseconds: 10), getTransactions);
    getTransactions();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  getTransactions() async {
    if (_app.loading) return;

    _transactions = [];
    setState(() => _app.loading = true);
    AccountModel me = Provider.of<AccountProvider>(context, listen: false).account;
    Response? response = await ApiService().get(ApiConstants.transaction, me.token);
    setState(() => _app.loading = false);

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
      'id': _app.me.id,
      'name': _app.me.name,
      'username': _app.me.username,
      'email': _app.me.email,
    });
    Navigator.push(context, MaterialPageRoute(builder: (_) => ShowQrCodeScreen(dataString: params)));
  }

  void onPressedPay(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ManualPayPage(buyer: _app.me)));
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

        if (seller.id == _app.me.id) {
          showDialog(
            context: context, 
            builder: (context) {
              return const ErrorDialog(text: "You are trying to pay to you.");
            }
          );

          return;
        }
        Navigator.push(context, MaterialPageRoute(builder: (_) => ScanPayPage(seller: seller, buyer: _app.me)));
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
          height: 40,
          child: FotocIconTextButton(
            icon: Icon(Icons.qr_code, size: 20, color: Theme.of(context).primaryColor),
            outline: true,
            buttonText: "Scan",
            onPressed: () => onPressedScan(context),
          )
        )
      ),
      const SizedBox(width: 20),
      Expanded(
        flex: 1,
        child: SizedBox(
          height: 40,
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

    if (_app.me.verifiedId != null) {
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
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
      Padding(padding: const EdgeInsets.only(top: 16, bottom: 24), child: ThumbnailBar(onPressedQrCode: onPressedQrCode, user: _app.me)),
    );

    widgets.add(Center(child: BalanceBox(user: _app.me)));

    widgets.add(Padding(padding: const EdgeInsets.only(top: 32), child: decorateButtons(context)));

    widgets.add(Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: TransactionsView(transactions: _transactions)));
    
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _app.me = context.watch<AccountProvider>().account;
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
              child: Column(children: decorateBody(context)),
            )
          )
        ],
      )
    );
  }
}
