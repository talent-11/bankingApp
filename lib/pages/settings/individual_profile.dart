import 'dart:convert';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:fotoc/constants.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/ui/radio_text.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';

class IndividualProfilePage extends StatefulWidget {
  const IndividualProfilePage({Key? key}) : super(key: key);

  @override
  State<IndividualProfilePage> createState() => _IndividualProfilePageState();
}

class _IndividualProfilePageState extends State<IndividualProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AccountModel _me;
  bool _loading = false;
  late String _name, _email, _username, _birth, _gender, _marital, _phone, _suite, _city, _state, _zipcode, _country;
  late TextEditingController _nameController, _emailController, _usernameController, _birthController, _phoneController, _suiteController, _cityController, _stateController, _zipcodeController;

  @override
  void initState() {
    super.initState();

    AccountModel me = Provider.of<AccountProvider>(context, listen: false).account;
    _nameController = TextEditingController(text: me.name!);
    _emailController = TextEditingController(text: me.email!);
    _usernameController = TextEditingController(text: me.username!);
    _phoneController = TextEditingController(text: me.phone!);
    _suiteController = TextEditingController(text: me.suite!);
    _cityController = TextEditingController(text: me.city!);
    _stateController = TextEditingController(text: me.state!);
    _zipcodeController = TextEditingController(text: me.zipcode!);
    _birthController = TextEditingController(text: me.birth!);
    
    setState(() {
      _me = me;
      _name = _me.name!;
      _email = _me.email!;
      _username = _me.username!;
      _birth = _me.birth!;
      _gender = _me.gender!;
      _marital = _me.marital!;
      _phone = _me.phone!;
      _suite = _me.suite!;
      _city = _me.city!;
      _state = _me.state!;
      _zipcode = _me.zipcode!;
      _country = _me.country!;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _suiteController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipcodeController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  void onPressedBack(BuildContext context) {
    Navigator.pop(context);
  }

  void updateProfile(BuildContext context) async {
    if (_loading) return;

    String token = Provider.of<AccountProvider>(context, listen: false).account.token!;

    setState(() => _loading = true);
    String params = jsonEncode(<String, dynamic>{
      'name': _name,
      'email': _email,
      'username': _username,
      'birth': _birth,
      'suite': _suiteController.text,
      'city': _cityController.text,
      'state': _stateController.text,
      'zipcode': _zipcodeController.text,
      'country': _country,
      'gender': _gender,
      'phone': _phoneController.text,
      'minor': 'False',
      'marital': _marital
    });
    Response? response = await ApiService().put(ApiConstants.profile, token, params);
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
      AccountModel user = AccountModel.fromJson(result['me']);
      context.read<AccountProvider>().setAccount(user);

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VerifyStep2Page()));
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

  void onPressedUpdate(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      updateProfile(context);
    }
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
        padding: const EdgeInsets.only(top: 24.0),
        child: Text("Update Profile", style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.center)
      )
    );

    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text("Information entered must match your I.D. uploaded:", style: Theme.of(context).textTheme.bodyText2, textAlign: TextAlign.center)
      )
    );

    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextInputField(
          enabled: false,
          controller: _nameController,
          hintText: "Enter your name",
          onChanged: (val) => setState(() => _name = val!),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
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
          enabled: false,
          controller: _emailController,
          hintText: "Enter your email",
          onChanged: (val) => setState(() => _name = val!),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
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
          enabled: false,
          controller: _usernameController,
          hintText: "Enter your username",
          onChanged: (val) => setState(() => _username = val!),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your username';
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
            controller: _birthController,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
                firstDate: DateTime(DateTime.now().year - 100),
                lastDate: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
              );
              if (pickedDate != null) {
                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                setState(() { _birthController.text = formattedDate; });
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Date of Birth';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Enter your Date of Birth",
              hintStyle: Theme.of(context).textTheme.bodyText1,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0)
            ),
          )
        )
      )
    );

    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffe8ecef), width: 1.0))),
          child: Row(
            children: <Widget>[
              RadioText(
                label: 'Male', 
                groupValue: _gender, 
                onChanged: (value) {
                  // setState(() { _gender = value.toString(); });
                }
              ),
              RadioText(
                label: 'Female', 
                groupValue: _gender, 
                onChanged: (value) {
                  // setState(() => _gender = value.toString());
                }
              ),
            ],
          ),
        )
      )
    );
    
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffe8ecef), width: 1.0))),
          child: Row(
            children: <Widget>[
              RadioText(label: 'Married', groupValue: _marital, onChanged: (value) => setState(() { _marital = value.toString(); })),
              RadioText(label: 'Single', groupValue: _marital, onChanged: (value) => setState(() { _marital = value.toString(); })),
              RadioText(label: 'Widowed', groupValue: _marital, onChanged: (value) => setState(() { _marital = value.toString(); })),
            ],
          ),
        )
      )
    );

    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextInputField(
          enabled: !_loading,
          controller: _phoneController,
          hintText: "Enter your phone number",
          onChanged: (val) => setState(() => _phone = val!),
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
        child: TextInputField(
          enabled: !_loading,
          controller: _suiteController,
          hintText: "Enter your house number and street name",
          onChanged: (val) => setState(() => _suite = val!),
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
          enabled: !_loading,
          controller: _cityController,
          hintText: "Enter your city",
          onChanged: (val) => setState(() => _city = val!),
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
          enabled: !_loading,
          controller: _stateController,
          hintText: "Enter your state or province",
          onChanged: (val) => setState(() => _state = val!),
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
          enabled: !_loading,
          controller: _zipcodeController,
          hintText: "Enter your zip or postal code",
          onChanged: (val) => setState(() => _zipcode = val!),
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
        initialSelection: _country,
        onChanged: (countryCode) => _country = countryCode!.code!,
        // Whether to allow the widget to set a custom UI overlay
        useUiOverlay: true,
        // Whether the country list should be wrapped in a SafeArea
        useSafeArea: true
      ),
    );

    widgets.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SizedBox(
          width: 200,
          height: 48,
          child: FotocButton(
            loading: _loading,
            buttonText: "Update",
            onPressed: () {
              onPressedUpdate(context);
            },
          ),
        )
      )
    );
    
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
                child: Column(children: decorateBody(context)),
              )
            )
          ),
        ],
      )
    );
  }
}
