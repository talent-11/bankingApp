import 'dart:convert';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/dropdown.dart';
import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/services/validation_service.dart';

class BusinessProfilePage extends StatefulWidget {
  const BusinessProfilePage({Key? key}) : super(key: key);

  @override
  State<BusinessProfilePage> createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AccountModel _me;
  bool _loading = false;
  late String _tax, _name, _email, _suite, _city, _state, _country, _phone;
  String? _type, _boi;
  late TextEditingController _nameController, _emailController, _taxController, _dooController, _phoneController, _suiteController, _cityController, _stateController;

  @override
  void initState() {
    super.initState();

    AccountModel me = Provider.of<AccountProvider>(context, listen: false).account;
    _nameController = TextEditingController(text: me.business!.name!);
    _emailController = TextEditingController(text: me.business!.email!);
    _taxController = TextEditingController(text: me.business!.taxId!);
    _phoneController = TextEditingController(text: me.business!.phone!);
    _suiteController = TextEditingController(text: me.business!.suite!);
    _cityController = TextEditingController(text: me.business!.city!);
    _stateController = TextEditingController(text: me.business!.state!);
    _dooController = TextEditingController(text: me.business!.doo!);
    
    setState(() {
      _me = me;
      _tax = _me.business!.taxId!;
      _name = _me.business!.name!;
      _email = _me.business!.email!;
      _phone = _me.business!.phone!;
      _suite = _me.business!.suite!;
      _city = _me.business!.city!;
      _state = _me.business!.state!;
      _country = _me.business!.country!;
      _type = _me.business!.type;
      _boi = _me.business!.boi;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _taxController.dispose();
    _phoneController.dispose();
    _suiteController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _dooController.dispose();
    super.dispose();
  }

  Future<void> updateProfile(BuildContext context) async {
    if (_loading) return;

    String token = Provider.of<AccountProvider>(context, listen: false).account.token!;

    setState(() => _loading = true);
    String params = jsonEncode(<String, dynamic>{
      'tax': _tax,
      'email': _email,
      'name': _name,
      'suite': _suite,
      'city': _city,
      'state': _state,
      'country': _country,
      'phone': _phone,
      'doo': _dooController.text,
      'type': _type,
      'boi': _boi
    });
    Response? response = await ApiService().post(ApiConstants.businessUpdate, token, params);
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

  void onPressedBack(BuildContext context) {
    Navigator.pop(context);
  }

  void onPressedUpdate(BuildContext context) {
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
        padding: const EdgeInsets.only(top: 24.0, bottom: 16),
        child: Text("Business details", style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.center)
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: TextInputField(
          controller: _taxController,
          hintText: "Tax ID Number",
          onChanged: (val) => setState(() => _tax = val!),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your tax ID number';
            }
            return null;
          },
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: TextInputField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          hintText: "Business Email",
          onChanged: (val) => setState(() => _email = val!),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter email';
            } else if (!value.isValidEmail) {
              return 'Please enter valid email';
            }
            return null;
          },
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: TextInputField(
          controller: _nameController,
          keyboardType: TextInputType.name,
          hintText: "Business Name",
          onChanged: (val) => setState(() => _name = val!),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your business name';
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
      CountryListPick(
        appBar: AppBar(backgroundColor: Theme.of(context).primaryColor, title: const Text('Select your country')),
        
        pickerBuilder: (context, CountryCode? countryCode) {
          String code = "", flagUrl = "";

          if (countryCode != null) {
            code = countryCode.name!;
            flagUrl = countryCode.flagUri!;
          }

          return Container(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffe8ecef), width: 1.0))),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Image.asset(flagUrl, package: 'country_list_pick', height: 14, fit: BoxFit.fitHeight),
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
        padding: const EdgeInsets.only(top: 0),
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
        padding: const EdgeInsets.only(top: 0),
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
        padding: const EdgeInsets.only(top: 0.0),
        child: Container(
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffe8ecef), width: 1.0))),
          child: TextFormField(
            enabled: !_loading,
            readOnly: true,
            controller: _dooController,
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
                  _dooController.text = formattedDate;
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: decorateBody(context),
                )
              )
            )
          ),
        ],
      ),
    );
  }
}
