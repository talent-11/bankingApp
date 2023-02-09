import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/pages/wizard/signup_almost.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:fotoc/services/validation_service.dart';
import 'package:fotoc/components/ui/primary_button.dart';
import 'package:fotoc/components/wizard/footer.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class AppState {
  bool loading;
  AccountModel user;

  AppState(this.loading, this.user);
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final app = AppState(false, AccountModel());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _visiblePassword = false;

  late String userEmail, userPassword, fcmToken;
  // late String userEmail='syedraharoontesting@gmail.com', userPassword='Asdf1234', fcmToken;

  Future<void> _login() async {
    if (app.loading) return;

    setState(() => app.loading = true);
    String params = jsonEncode(<String, dynamic>{
      'email': userEmail.toLowerCase(),
      'password': userPassword,
      'fcm_token': fcmToken
    });
    Response? response = await ApiService().post(ApiConstants.login, '', params);
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
      user.token = result['token'];
      context.read<AccountProvider>().setAccount(user);
      context.read<AccountProvider>().login(true);

      Navigator.pushNamedAndRemoveUntil(context, '/free/main', (route) => false);
    } else if (response.statusCode == 400) {
      showDialog(
        context: context, 
        builder: (context) {
          dynamic res = json.decode(response.body);
          String text = res["message"];
          return ErrorDialog(text: text);
        }
      );
    } else if (response.statusCode == 403) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignupAlmostPage(from: 'login', email: userEmail)));
    }
  }

  void onPressedLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _login();
    }
    // _login();
  }

  void onPressedRecover(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/wizard/recover');
  }

  void onPressedSignup(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/wizard/signup/start');
  }

  void onPressedShowPassword(BuildContext context) {
    setState(() {
      _visiblePassword = !_visiblePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    fcmToken = context.watch<AccountProvider>().fcmToken;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage("assets/images/wizard01.png")
                      )
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: FractionalOffset.bottomRight,
                        end: FractionalOffset.topLeft,
                        colors: [
                          const Color(0xff2a14f6).withOpacity(0.6),
                          const Color(0xffe409f9).withOpacity(0.6)
                        ],
                      )
                    ),
                  )
                ],
              )
            ),
            SizedBox(
              width: deviceSize.width,
              height: 428.0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Text("Sign in to your account", style: Theme.of(context).textTheme.headline1)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 22.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: TextInputField(
                              enabled: !app.loading,
                              labelText: "Your account",
                              hintText: "Enter your email",
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (val) => userEmail = val!,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email';
                                } else if (!value.isValidEmail) {
                                  return 'Please enter valid email';
                                }
                                return null;
                              },
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: TextInputField(
                              enabled: !app.loading,
                              labelText: "Password",
                              hintText: "Enter your password",
                              obscureText: !_visiblePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _visiblePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  onPressedShowPassword(context);
                                },
                              ),
                              onSaved: (val) => userPassword = val!,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            )
                          ),
                        ],
                      ),
                    )
                  ),
                  const Spacer(flex: 1),
                  TextButton(
                    onPressed: () {
                      onPressedRecover(context);
                    },
                    child: Text("Recover password", style: Theme.of(context).textTheme.headline6)
                  ),
                  const Spacer(flex: 1),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                    child: PrimaryButton(
                      loading: app.loading,
                      buttonText: "SIGN IN",
                      onPressed: () {
                        onPressedLogin(context);
                      }
                    ),
                  ),
                  WizardFooter(
                    description: "Don't have an account?",
                    buttonText: "Sign up here",
                    onPressed: () {
                      onPressedSignup(context);
                    }
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
