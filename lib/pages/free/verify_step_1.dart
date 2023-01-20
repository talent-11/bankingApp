import 'dart:convert';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/pages/wizard/signup_start.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  late String fullName, username, email, gender = 'Male', phone, suite, city, state, zipcode, country = 'US', newPassword, rePassword, fcmToken;
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    dynamic showSignupMainPage() => {
      if (app.user.email == null) {
        // Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupMainPage(from: "verify")))
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupStartPage(from: "verify")))
      }
    };

    Future.delayed(const Duration(milliseconds: 200), showSignupMainPage);
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  void _update(BuildContext context, String token) async {
    if (app.loading) return;

    setState(() => app.loading = true);
    String params = jsonEncode(<String, dynamic>{
      'suite': suite,
      'city': city,
      'state': state,
      'zipcode': zipcode,
      'country': country,
      'gender': gender,
      'phone': phone,
      'birth': dateController.text,
      'minor': 'False',
      'marital': 'married'
    });
    Response? response = await ApiService().put(ApiConstants.profile, token, params);
    setState(() => app.loading = false);

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
      context.read<CurrentAccount>().setAccount(user);
      context.read<CurrentAccount>().login(true);

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

  void onPressedNext(BuildContext context, String? token) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _update(context, token!);
    }
    // Navigator.pushNamed(context, '/free/verify/2');
  }

  // void onPressedCancel(BuildContext context) {
  //   Navigator.pop(context);
  // }

  List<Widget> decorateBody(BuildContext context, AccountModel user) {
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
            enabled: !app.loading,
            readOnly: true,
            controller: dateController,
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
                  dateController.text = formattedDate;
                });
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Birth of Date';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Enter your Birth of Date",
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
    List genders=["Male", "Female", "Other"];
    Row addRadioButton(int btnValue, String title) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Radio<String>(
            activeColor: Theme.of(context).primaryColor,
            value: genders[btnValue],
            groupValue: gender,
            onChanged: (value){
              setState(() {
                gender = value.toString();
              });
            },
          ),
          Text(title)
        ],
      );
    }
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
              addRadioButton(0, 'Male'),
              addRadioButton(1, 'Female'),
              addRadioButton(2, 'Other'),
            ],
          ),
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextInputField(
          enabled: !app.loading,
          hintText: "Enter your phone number",
          onChanged: (val) {
            setState(() => phone = val!);
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
          enabled: !app.loading,
          hintText: "Enter your house number and street name",
          onChanged: (val) {
            setState(() => suite = val!);
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
          enabled: !app.loading,
          hintText: "Enter your city",
          onChanged: (val) {
            setState(() => city = val!);
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
          enabled: !app.loading,
          hintText: "Enter your state or province",
          onChanged: (val) {
            setState(() => state = val!);
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
          enabled: !app.loading,
          hintText: "Enter your zip or postal code",
          onChanged: (val) {
            setState(() => zipcode = val!);
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
        initialSelection: country,
        onChanged: (countryCode) => country = countryCode!.code!,
        // Whether to allow the widget to set a custom UI overlay
        useUiOverlay: true,
        // Whether the country list should be wrapped in a SafeArea
        useSafeArea: true
      ),
    );
    return widgets;
  }

  Widget footer(BuildContext context, String? token) => Column(
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
                  loading: app.loading,
                  buttonText: "Next",
                  onPressed: () {
                    onPressedNext(context, token);
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
    AccountModel me = context.watch<CurrentAccount>().account;
    app.user = me;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: decorateBody(context, me)
                ),
              )
            )
          ),
          footer(context, me.token)
        ],
      )
    );
  }
}
