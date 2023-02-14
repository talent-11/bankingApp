import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:fotoc/constants.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:fotoc/models/notifications_model.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/providers/settings_provider.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/text_with_cc.dart';

class NotificationsListPage extends StatefulWidget {
  const NotificationsListPage({Key? key}) : super(key: key);

  @override
  State<NotificationsListPage> createState() => _NotificationsListPageState();
}

class _NotificationsListPageState extends State<NotificationsListPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AccountModel _me;
  bool _loading = false;
  late List<NotificationsModel> _notifications;

  @override
  void initState() {
    super.initState();

    AccountModel me = Provider.of<AccountProvider>(context, listen: false).account;
    
    setState(() {
      _me = me;
    });

    getNotifications();
  }

  getNotifications() async {
    if (_loading) return;

    _notifications = [];
    setState(() => _loading = true);
    String bizzAccount = Provider.of<SettingsProvider>(context, listen: false).bizzAccount;
    String url = ApiConstants.notifications + "?type=" + bizzAccount + "&id=" + (bizzAccount == Ext.business ? _me.business!.id.toString() : _me.id.toString());
    Response? response = await ApiService().get(url, _me.token);
    setState(() => _loading = false);

    if (response != null && response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      for (Map<String, dynamic> notifications in data) {
        _notifications.add(NotificationsModel(title: notifications["title"], body: notifications["body"]));
      }
    }
  }

  void onPressedBack(BuildContext context) {
    Navigator.pop(context);
  }
  
  IconButton backButton(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back_ios, size: 32.0),
    onPressed: () => onPressedBack(context), 
    color: Colors.white,
  );

  List<Widget> decorateBody(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 24.0, bottom: 16),
        child: Text("Notifications", style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.center)
      )
    );
    if (_notifications.isEmpty) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text("There is no notifications.", style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.center)
        )
      );
    } else {
      widgets.add(const SizedBox(height: 0));
      for (int i = 0; i < _notifications.length; i ++) {
        widgets.add(
          // Row(
          //   children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), 
                child: TextWithCC(
                  text: (_notifications[i].title + ": " + _notifications[i].body),
                  fontSize: 15,
                  color: const Color(0xff98a9bc),
                )
              )
              
            // ]
          // )
          
        );
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LogoBar(iconButton: backButton(context)),
          Expanded(
            flex: 1,
            child: _loading ? 
              Center(
                child: SizedBox(width: 40, height: 40, child: CircularProgressIndicator(color: Theme.of(context).primaryColor))
              ) :
              ListView(
                children: decorateBody(context),
              )
          ),
        ],
      ),
    );
  }
}
