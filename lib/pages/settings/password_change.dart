import 'dart:convert';

import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:fotoc/constants.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:fotoc/services/validation_service.dart';
import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';

class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({Key? key}) : super(key: key);

  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  late String _newPassword, _oldPassword;
  late List<bool> _visiblePasswords;

  @override
  void initState() {
    super.initState();
    
    setState(() {
      _visiblePasswords = [false, false, false];
    });
  }

  void onPressedBack(BuildContext context) {
    Navigator.pop(context);
  }

  void onPressedShowPassword(BuildContext context, int index) {
    setState(() {
      _visiblePasswords[index] = !_visiblePasswords[index];
    });
  }

  void changePassword(BuildContext context) async {
    if (_loading) return;

    String token = Provider.of<AccountProvider>(context, listen: false).account.token!;

    setState(() => _loading = true);
    String params = jsonEncode(<String, dynamic>{
      'old_password': _oldPassword,
      'new_password': _newPassword,
    });
    Response? response = await ApiService().put(ApiConstants.changePassword, token, params);
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
      context.read<AccountProvider>().setAccountToken(result['token']);

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

  IconButton backButton(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back_ios, size: 32.0),
    onPressed: () => onPressedBack(context), 
    color: Colors.white,
  );

  void onPressedChange(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      changePassword(context);
    }
  }

  List<Widget> decorateBody(BuildContext context) {
    var widgets = <Widget>[];

    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Text("Change Password", style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.center)
      )
    );

    widgets.add(const SizedBox(height: 32));

    widgets.add(
      TextInputField(
        enabled: !_loading,
        labelText: "Old Password",
        hintText: "Enter your old password",
        obscureText: !_visiblePasswords[0],
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _visiblePasswords[0]
            ? Icons.visibility
            : Icons.visibility_off,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            onPressedShowPassword(context, 0);
          },
        ),
        onChanged: (val) => _oldPassword = val!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
      )
    );
    
    widgets.add(const SizedBox(height: 8));

    widgets.add(
      TextInputField(
        enabled: !_loading,
        labelText: "New Password",
        hintText: "Enter your new password",
        obscureText: !_visiblePasswords[1],
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _visiblePasswords[1]
            ? Icons.visibility
            : Icons.visibility_off,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            onPressedShowPassword(context, 1);
          },
        ),
        onChanged: (val) => _newPassword = val!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter new password';
          } else if (!value.isValidPassword) {
            return 'Please enter valid password(At least a letter and a number, and 8 characters)';
          }
        },
      )
    );

    widgets.add(const SizedBox(height: 8));

    widgets.add(
      TextInputField(
        enabled: !_loading,
        labelText: "Confirm Password",
        hintText: "Enter your confirm password",
        obscureText: !_visiblePasswords[2],
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _visiblePasswords[2]
            ? Icons.visibility
            : Icons.visibility_off,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            onPressedShowPassword(context, 2);
          },
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please reenter your new password';
          } else if (value != _newPassword) {
            return 'Confirm password doesn\'t match';
          }
          return null;
        },
      )
    );

    widgets.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: SizedBox(
          width: 200,
          height: 48,
          child: FotocButton(
            loading: _loading,
            buttonText: "Change",
            onPressed: () {
              onPressedChange(context);
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
                  children: decorateBody(context)
                ),
              )
            )
          ),
        ],
      )
    );
  }
}
