import 'dart:convert';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/components/ui/primary_button.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:http/http.dart';

class AppState {
  bool loading;
  AccountModel user;

  AppState(this.loading, this.user);
}

class VerifyStep1Page extends StatefulWidget {
  const VerifyStep1Page({Key? key}) : super(key: key);

  @override
  State<VerifyStep1Page> createState() => _VerifyStep1PageState();
}

class _VerifyStep1PageState extends State<VerifyStep1Page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final app = AppState(false, AccountModel());

  late String address, city, state, zipcode, country = 'US';

  
  Future<void> _update(BuildContext context) async {
    if (app.loading) return;

    setState(() => app.loading = true);
    String params = jsonEncode(<String, dynamic>{
      'address': address,
      'city': city,
      'state': state,
      'zipcode': zipcode,
      'country': country,
    });
    Response? response = await ApiService().post(ApiConstants.profile, '', params);
    setState(() => app.loading = false);

    if (response == null) {
      showDialog(
        context: context, 
        builder: (context) {
          return const ErrorDialog(text: "Please check your network connection");
        }
      );
    } else if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/free/verify/2');
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
    // if (_formKey.currentState!.validate()) {
    //   _formKey.currentState!.save();
    //   _update(context);
    // }
    Navigator.pushNamed(context, '/free/verify/3');
  }

  List<Widget> decorate(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(const LogoBar());
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Text(
          "Account details",
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          "Information entered must match your I.D. uploaded in Step 2:",
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.center,
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextInputField(
          enabled: !app.loading,
          hintText: "Enter your house number and street name",
          onSaved: (val) => address = val!,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your address';
            }
            return null;
          },
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextInputField(
          // labelText: "Your name",
          enabled: !app.loading,
          hintText: "Enter your city",
          onSaved: (val) => city = val!,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your city';
            }
            return null;
          },
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextInputField(
          enabled: !app.loading,
          hintText: "Enter your state or province",
          onSaved: (val) => state = val!,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your state or province';
            }
            return null;
          },
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: TextInputField(
          enabled: !app.loading,
          hintText: "Enter your zip or postal code",
          onSaved: (val) => zipcode = val!,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your zip or postal code';
            }
            return null;
          },
        )
      )
    );
    widgets.add(
      CountryListPick(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Select your country'),
        ),
        
        // if you need custome picker use this
        pickerBuilder: (context, CountryCode? countryCode) {
          String code = "", flagUrl = "";

          if (countryCode != null) {
            code = countryCode.name!;
            flagUrl = countryCode.flagUri!;
          }

          return Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffe8ecef), width: 1.0))
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Image.asset(
                      flagUrl,
                      package: 'country_list_pick',
                      // width: 20,
                      height: 14,
                      fit: BoxFit.fitHeight
                    ),
                  ),
                  Expanded(child: Text(code, style: Theme.of(context).textTheme.headline6)),
                  Icon(Icons.arrow_drop_down, size: 20, color: Theme.of(context).primaryColor),
                ],
              ),
            )
          );
        },

        // To disable option set to false
        theme: CountryTheme(
          labelColor: const Color(0xff98a9bc),
          showEnglishName: true,
        ),
        // Set default value
        initialSelection: 'US',
        onChanged: (countryCode) => country = countryCode!.code!,
        // Whether to allow the widget to set a custom UI overlay
        useUiOverlay: true,
        // Whether the country list should be wrapped in a SafeArea
        useSafeArea: true
      ),
    );
    return widgets;
  }

  Widget footer(BuildContext context) => Column(
    children: [
      PrimaryButton(
        loading: app.loading,
        buttonText: "NEXT & UPLOAD YOUR I.D.",
        onPressed: () {
          onPressedNext(context);
        }
      ),
      const Dots(selectedIndex: 0),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: decorate(context)
              ),
            )
          ),
          footer(context)
        ],
      )
    );
  }
}
