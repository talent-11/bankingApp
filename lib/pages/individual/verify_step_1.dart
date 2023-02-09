import 'dart:convert';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/ui/radio_text.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';
import 'package:fotoc/pages/individual/verify_step_2.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/services/api_service.dart';

class VerifyStep1Page extends StatefulWidget {
  const VerifyStep1Page({Key? key}) : super(key: key);

  @override
  State<VerifyStep1Page> createState() => _VerifyStep1PageState();
}

class _VerifyStep1PageState extends State<VerifyStep1Page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;

  late String _gender = 'Male', _marital = 'Married', _phone, _suite, _city, _state, _zipcode, _country = 'US';
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _update(BuildContext context) async {
    if (_loading) return;

    String token = Provider.of<AccountProvider>(context, listen: false).account.token!;

    setState(() => _loading = true);
    String params = jsonEncode(<String, dynamic>{
      'suite': _suite,
      'city': _city,
      'state': _state,
      'zipcode': _zipcode,
      'country': _country,
      'gender': _gender,
      'phone': _phone,
      'birth': _dateController.text,
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
      context.read<AccountProvider>().login(true);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VerifyStep2Page()));
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
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _update(context);
    }
  }

  List<Widget> decorateBody(BuildContext context) {
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
          "Information entered must match your I.D. uploaded in Step 3:",
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.center,
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xffe8ecef), width: 1.0)
            )
          ),
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

    // List genders=["Male", "Female"];
    // Row addRadioButton(int btnValue, String title) {
    //   return Row(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: <Widget>[
    //       Radio<String>(
    //         activeColor: Theme.of(context).primaryColor,
    //         value: genders[btnValue],
    //         groupValue: _gender,
    //         onChanged: (value){
    //           setState(() {
    //             _gender = value.toString();
    //           });
    //         },
    //       ),
    //       Text(title)
    //     ],
    //   );
    // }
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xffe8ecef), width: 1.0)
            )
          ),
          child: Row(
            children: <Widget>[
              // addRadioButton(0, 'Male'),
              // addRadioButton(1, 'Female'),
              RadioText(
                label: 'Male', 
                groupValue: _gender, 
                onChanged: (value) {
                  setState(() {
                    _gender = value.toString();
                  });
                }
              ),
              RadioText(
                label: 'Female', 
                groupValue: _gender, 
                onChanged: (value) {
                  setState(() {
                    _gender = value.toString();
                  });
                }
              ),
            ],
          ),
        )
      )
    );

    // List maritals=["Married", "Single", "Widowed"];
    // Row addRadioButton1(int btnValue, String title) {
    //   return Row(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: <Widget>[
    //       Radio<String>(
    //         activeColor: Theme.of(context).primaryColor,
    //         value: maritals[btnValue],
    //         groupValue: _marital,
    //         onChanged: (value){
    //           setState(() {
    //             _marital = value.toString();
    //           });
    //         },
    //       ),
    //       Text(title)
    //     ],
    //   );
    // }
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xffe8ecef), width: 1.0)
            )
          ),
          child: Row(
            children: <Widget>[
              // addRadioButton1(0, 'Married'),
              // addRadioButton1(1, 'Single'),
              // addRadioButton1(2, 'Widowed'),
              RadioText(
                label: 'Married', 
                groupValue: _marital, 
                onChanged: (value) {
                  setState(() {
                    _marital = value.toString();
                  });
                }
              ),
              RadioText(
                label: 'Single', 
                groupValue: _marital, 
                onChanged: (value) {
                  setState(() {
                    _marital = value.toString();
                  });
                }
              ),
              RadioText(
                label: 'Widowed', 
                groupValue: _marital, 
                onChanged: (value) {
                  setState(() {
                    _marital = value.toString();
                  });
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
        child: TextInputField(
          enabled: !_loading,
          hintText: "Enter your phone number",
          onChanged: (val) {
            setState(() => _phone = val!);
          },
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
          hintText: "Enter your house number and street name",
          onChanged: (val) {
            setState(() => _suite = val!);
          },
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
          enabled: !_loading,
          hintText: "Enter your city",
          onChanged: (val) {
            setState(() => _city = val!);
          },
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
          hintText: "Enter your state or province",
          onChanged: (val) {
            setState(() => _state = val!);
          },
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
          hintText: "Enter your zip or postal code",
          onChanged: (val) {
            setState(() => _zipcode = val!);
          },
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
    return widgets;
  }

  Widget footer(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            // Expanded(
            //   flex: 1,
            //   child: SizedBox(
            //     height: 48,
            //     child: FotocButton(
            //       outline: true,
            //       buttonText: "Cancel",
            //       onPressed: () {
            //         onPressedCancel(context);
            //       },
            //     ),
            //   )
            // ),
            // const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 48,
                child: FotocButton(
                  loading: _loading,
                  buttonText: "Next",
                  onPressed: () {
                    onPressedNext(context);
                  },
                ),
              )
            ),
          ]
        ),
      ),
      const Dots(selectedIndex: 2, dots: 6),
    ],
  );

  @override
  Widget build(BuildContext context) {
    AccountModel me = context.watch<AccountProvider>().account;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: decorateBody(context)
                ),
              )
            )
          ),
          footer(context)
        ],
      )
    );
  }
}
