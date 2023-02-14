import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/search_bar.dart';
import 'package:fotoc/providers/settings_provider.dart';
import 'package:http/http.dart';

import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:provider/provider.dart';


class AppState {
  bool loading;

  AppState(this.loading);
}

class PeoplePage extends StatefulWidget {
  const PeoplePage({Key? key, required this.me}) : super(key: key);

  final AccountModel me;
  
  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  final _app = AppState(false);
  String _searchString = "";
  List<AccountModel> _peoples = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPeoples();
  }

  getPeoples() async {
    if (_app.loading) return;

    _peoples = [];
    setState(() => _app.loading = true);
    Response? response = await ApiService().get(ApiConstants.account, widget.me.token);
    setState(() => _app.loading = false);

    if (response != null && response.statusCode == 200) {
      _peoples = userModelFromJson(response.body);
      _peoples = _peoples.where((element) => element.verifiedId != "").toList();
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

  void onPressedBack(BuildContext context) {
    Navigator.pop(context);
  }

  void onPressedAccount(BuildContext context, int id, String type, String name) {
    Navigator.pop(context, {'id': id, 'name': name, 'type': type});
  }

  Widget decorateSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 0, top: 8),
      child: FotocSearchBar(
        controller: _controller,
        onPressedClear: () {
          _controller.text = "";
          setState(() => _searchString = "");
        },
        onChanged: (value) => setState(() => _searchString = value),
      )
    );
  }

  IconButton backButton(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back_ios, size: 32.0),
    onPressed: () => onPressedBack(context), 
    color: Colors.white,
  );

  Widget decorateAccount(BuildContext context, int id, String type, String name, String username) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16), 
      child: TextButton(
        onPressed: () {
          onPressedAccount(context, id, type, name);
        },
        child: Row(
          children: [
            Icon(
              Icons.account_circle,
              color: Theme.of(context).primaryColor,
              size: 60.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name, 
                    style: TextStyle(
                      color: Theme.of(context).primaryColor, 
                      decoration: TextDecoration.underline, 
                      decorationThickness: 1.5,
                      fontSize: 18, 
                      fontWeight: FontWeight.w500
                    )
                  ),
                  Text(
                    (type == Ext.business ? "Owner: " : "") + "@" + username,
                    style: Theme.of(context).textTheme.headline6,
                  )
                ],
              )
            )
          ]
        )
      ),
    );
  }

  Widget decorateList(BuildContext context) {
    bool isBusiness = Provider.of<SettingsProvider>(context, listen: false).bizzAccount == Ext.business;
    List<Widget> widgets = [];
    int myId = isBusiness ? widget.me.business!.id! : widget.me.id!;
    List<AccountModel> newPeoples = _peoples.where((element) => 
      (element.name!.toLowerCase().contains(_searchString.toLowerCase()) || element.username!.toLowerCase().contains(_searchString.toLowerCase())) && element.id != myId
    ).toList();
    
    for (var account in newPeoples) {
      widgets.add(decorateAccount(context, account.id!, Ext.individual, account.name!, account.username!));
    }
    
    bool hasBusinesses = false;
    for (var account in _peoples) {
      if (account.business == null) continue;
      BusinessModel bizz = account.business!;
      if (bizz.verified! && bizz.name!.toLowerCase().contains(_searchString.toLowerCase()) && bizz.id != myId) {
        hasBusinesses = true;
        widgets.add(decorateAccount(context, bizz.id!, Ext.business, bizz.name!, account.username!));
      }
    }

    if (newPeoples.isEmpty && !hasBusinesses) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text("There is no verified account.", style: Theme.of(context).textTheme.headline1)
        )
      );
    }
    
    return Column(children: widgets);
  }

  Widget decorateBody(BuildContext context) {
    return Expanded(
      child: _app.loading ? 
        Center(
          child: SizedBox(width: 40, height: 40, child: CircularProgressIndicator(color: Theme.of(context).primaryColor))
        )
      : 
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
            child: decorateList(context)
          )
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          LogoBar(iconButton: backButton(context)),
          decorateSearchBar(context),
          decorateBody(context)
        ]
      ),
    );
  }
}
