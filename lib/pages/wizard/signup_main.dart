import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/components/ui/primary_button.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/footer.dart';
import 'package:fotoc/components/wizard/labeled_checkbox.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:fotoc/services/validation_service.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/pages/wizard/signup_almost.dart';
import 'package:fotoc/pages/wizard/login.dart';
import 'package:fotoc/pages/individual/verify_step_1.dart';

class SignupMainPage extends StatefulWidget {
  const SignupMainPage({Key? key, this.from, this.friendId}) : super(key: key);

  final String? from;
  final String? friendId;

  @override
  State<SignupMainPage> createState() => _SignupMainPageState();
}

class _SignupMainPageState extends State<SignupMainPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _agreed = false;
  bool _visiblePassword = false;
  bool _visibleConfirmPassword = false;
  late String _name, _email, _username, _newPassword;

  Future<void> _signup(BuildContext context) async {
    if (_loading) return;

    if (!_agreed) {
      showDialog(
        context: context, 
        builder: (context) {
          return const ErrorDialog(text: "You must agree with terms and conditions");
        }
      );
      return;
    }

    String fcmToken = Provider.of<AccountProvider>(context, listen: false).fcmToken;

    setState(() => _loading = true);
    String params = jsonEncode(<String, dynamic>{
      'name': _name,
      'email': _email.toLowerCase(),
      'username': _username.toLowerCase(),
      'password': _newPassword,
      'friend_id': widget.friendId,
      'fcm_token': fcmToken,
    });
    Response? response = await ApiService().post(ApiConstants.signup, '', params);
    setState(() => _loading = false);

    if (response == null) {
      showDialog(
        context: context, 
        builder: (context) {
          return const ErrorDialog(text: "Please check your network connection");
        }
      );
    } else if (response.statusCode == 200) {
      int count = 0;
      if (widget.from == "verify") {
        dynamic result = json.decode(response.body);
        context.read<AccountProvider>().setAccountToken(result['token']);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const VerifyStep1Page()), (route) {
          return count ++ == 2;
        });
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SignupAlmostPage()), (route) {
          return count ++ == 2;
        });
      }
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
      _signup(context);
    }
  }

  void onPressedSignin(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }
  
  void onPressedShowPassword(BuildContext context) {
    setState(() { _visiblePassword = !_visiblePassword; });
  }

  void onPressedShowConfirmPassword(BuildContext context) {
    setState(() { _visibleConfirmPassword = !_visibleConfirmPassword; });
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
          enabled: !_loading,
          keyboardType: TextInputType.name,
          hintText: "Enter your full name",
          onChanged: (val) { setState(() => _name = val!); },
          validator: (value) {
            if (value == null || value.isEmpty) {
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
          enabled: !_loading,
          hintText: "Enter your email",
          keyboardType: TextInputType.emailAddress,
          onChanged: (val) { setState(() => _email = val!); },
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
          enabled: !_loading,
          hintText: "Enter your username",
          onChanged: (val) { setState(() => _username = val!); },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter username';
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
          enabled: !_loading,
          obscureText: !_visiblePassword,
          hintText: "Enter your password",
          suffixIcon: IconButton(
            icon: Icon(
              _visiblePassword ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () { onPressedShowPassword(context); },
          ),
          onChanged: (val) { setState(() => _newPassword = val!); },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter password';
            } else if (!value.isValidPassword) {
              return 'Please enter valid password(At least a letter and a number, and 8 characters)';
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
          enabled: !_loading,
          obscureText: !_visibleConfirmPassword,
          hintText: "Confirm your password",
          suffixIcon: IconButton(
            icon: Icon(
              _visibleConfirmPassword ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () { onPressedShowConfirmPassword(context); },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please reenter your password';
            } else if (value != _newPassword) {
              return 'Confirm password doesn\'t match';
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
          checked: _agreed,
          valueChanged: (bool? value) { setState(() => _agreed = value!); }
        )
      )
    );
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
    if (widget.from != "verify") {
      widgets.add(
        WizardFooter(
          description: "Do you have an account?",
          buttonText: "Sign in here",
          onPressed: () {
            onPressedSignin(context);
          }
        )
      );
      widgets.add(const Dots(selectedIndex: 1, dots: 3));
    } else {
      widgets.add(const Dots(selectedIndex: 1, dots: 6));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const LogoBar(),
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
