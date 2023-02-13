import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/pages/individual/verify_step_3.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/components/ui/primary_button.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/ui/dropdown.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:fotoc/providers/account_provider.dart';

class BusinessVerify3Page extends StatefulWidget {
  const BusinessVerify3Page({
    Key? key, 
    required this.tax,
    required this.name,
    required this.email,
    required this.suite,
    required this.city,
    required this.state,
    required this.country,
  }) : super(key: key);

  final String tax;
  final String name;
  final String email;
  final String suite;
  final String city;
  final String state;
  final String country;

  @override
  State<BusinessVerify3Page> createState() => _BusinessVerify3PageState();
}

class _BusinessVerify3PageState extends State<BusinessVerify3Page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  late String _phone;
  String? _type, _boi;
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _signup(BuildContext context) async {
    if (_loading) return;

    String token = Provider.of<AccountProvider>(context, listen: false).account.token!;

    setState(() => _loading = true);
    String params = jsonEncode(<String, dynamic>{
      'tax': widget.tax,
      'email': widget.email,
      'name': widget.name,
      'suite': widget.suite,
      'city': widget.city,
      'state': widget.state,
      'country': widget.country,
      'phone': _phone,
      'doo': _dateController.text,
      'type': _type,
      'boi': _boi
    });
    Response? response = await ApiService().post(ApiConstants.businessSignup, token, params);
    setState(() => _loading = false);

    if (response == null) {
      showDialog(
        context: context, 
        builder: (context) {
          return const ErrorDialog(text: "Please check your network connection");
        }
      );
    } else if (response.statusCode == 200) {
      dynamic result = json.decode(response.body);
      BusinessModel business = BusinessModel.fromJson(result['business']);
      AccountModel user = Provider.of<AccountProvider>(context, listen: false).account;
      user.business = business;
      context.read<AccountProvider>().setAccount(user);
      
      const snackBar = SnackBar(content: Text('We\'ve just sent a verification email'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.push(context, MaterialPageRoute(builder: (_) => VerifyStep3Page(from: Ext.business)));
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

  void onPressedBack(BuildContext context) {
    Navigator.pop(context);
  }

  void onPressedNext(BuildContext context) {
    String? err;
    if (_boi == null) {
      err = "Please select Business/Industry";
    }
    if (_type == null) {
      err = "Please select Business Type";
    }
    if (err != null) {
      showDialog(
        context: context, 
        builder: (context) {
          return ErrorDialog(text: err!);
        }
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      _signup(context);
    }
  }

  IconButton backButton(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back_ios, size: 32.0),
    onPressed: () => onPressedBack(context), 
    color: Colors.white,
  );

  List<Widget> decorate(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 24.0, bottom: 16),
        child: Text(
          "Business details",
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: FotocDropdown(
          placeholder: "Business Type", 
          list: Ext.businessType,
          buttonWidth: 160,
          selectedValue: _type,
          onChanged: (value) {
            if (_loading) return;
            setState(() { _type = value; });
          },
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: FotocDropdown(
          placeholder: "Business/Industry", 
          list: Ext.businessOrIndustry,
          buttonWidth: 160,
          selectedValue: _boi,
          onChanged: (value) {
            if (_loading) return;
            setState(() { _boi = value; });
          },
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextInputField(
          enabled: !_loading,
          hintText: "Phone Number",
          onChanged: (val) { setState(() => _phone = val!); },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffe8ecef), width: 1.0))),
          child: TextFormField(
            enabled: !_loading,
            readOnly: true,
            controller: _dateController,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(), //get today's date
                firstDate:DateTime(1900), //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2101)
              );
              if (pickedDate != null) {
                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                
                setState(() {
                  _dateController.text = formattedDate;
                });
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter your date of organization';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Date of Organization",
              hintStyle: Theme.of(context).textTheme.bodyText1,
              border: const OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0)
            ),
          )
        )
      )
    );
    widgets.add(const SizedBox(height: 16.0));
    return widgets;
  }

  List<Widget> decorateFooter(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(
      PrimaryButton(
        loading: _loading,
        buttonText: "NEXT",
        onPressed: () {
          onPressedNext(context);
        }
      )
    );
    // widgets.add(const Dots(selectedIndex: 1, dots: 6));
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LogoBar(iconButton: backButton(context)),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: decorate(context),
                )
              )
            )
          ),
          Column(children: decorateFooter(context)),
        ],
      ),
    );
  }
}
