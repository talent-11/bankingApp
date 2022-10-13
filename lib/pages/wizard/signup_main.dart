import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/components/ui/primary_button.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/footer.dart';
import 'package:fotoc/components/wizard/labeled_checkbox.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/pages/wizard/login.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:fotoc/services/validation_service.dart';
import 'package:http/http.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:provider/provider.dart';

class SignupMainPage extends StatefulWidget {
  const SignupMainPage({Key? key}) : super(key: key);

  @override
  State<SignupMainPage> createState() => _SignupMainPageState();
}

class _SignupMainPageState extends State<SignupMainPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final app = AppState(false, AccountModel());

  bool agreed = false;
  late String userName, userEmail, userPassword, referralId;

  Future<void> _signup(BuildContext context) async {
    if (app.loading) return;

    setState(() => app.loading = true);
    String params = jsonEncode(<String, dynamic>{
      'name': userName,
      'email': userEmail,
      'password': userPassword,
      'friend_id': referralId,
      'country': 'US',
    });
    Response? response = await ApiService().post(ApiConstants.signup, '', params);
    setState(() => app.loading = false);

    if (response == null) {
      showDialog(
        context: context, 
        builder: (context) {
          return const ErrorDialog(text: "Please check your network connection");
        }
      );
    } else if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/wizard/signup/almost');
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
      _signup(context);
    }
  }

  void onPressedSignin(BuildContext context) {
    Navigator.pushNamed(context, '/wizard/login');
  }

  List<Widget> decorate(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 24.0, bottom: 16),
        child: Text(
          "Account details",
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: TextInputField(
          // labelText: "Your name",
          enabled: !app.loading,
          hintText: "Enter your full name",
          onSaved: (val) => userName = val!,
          validator: (value) {
            if (value == null) {
              return 'Please enter your full name';
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
          // labelText: "Your account",
          enabled: !app.loading,
          hintText: "Enter your email",
          onSaved: (val) => userEmail = val!,
          validator: (value) {
            if (value == null) {
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
          // labelText: "Create password",
          enabled: !app.loading,
          hintText: "Enter your password",
          onSaved: (val) => userPassword = val!,
          validator: (value) {
            if (value == null) {
              return 'Please enter password';
            } else if (!value.isValidPassword) {
              return 'Please enter valid password(At least a letter and a number)';
            }
            return null;
          },
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 20.0),
        child: LabeledCheckbox(
          labelText: "I agree with terms & conditions",
          checked: agreed,
          valueChanged: (bool? value) {
            setState(() {
              agreed = value!;
            });
          }
        )
      )
    );
    return widgets;
  }

  Widget footer(BuildContext context) => Column(
    children: [
      PrimaryButton(
        loading: app.loading,
        buttonText: "NEXT",
        onPressed: () {
          onPressedNext(context);
        }
      ),
      const Dots(selectedIndex: 1),
      WizardFooter(
        description: "Do you have an account?",
        buttonText: "Sign in here",
        onPressed: () {
          onPressedSignin(context);
        }
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    referralId = context.watch<CurrentAccount>().account.friendId!;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const LogoBar(),
          SizedBox(
            height: (deviceSize.height - 148.4 - logoHeight),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: decorate(context),
              )
            )
          ),
          footer(context),
        ],
      ),
    );
  }
}
