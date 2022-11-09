import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fotoc/components/gradient_rectangle.dart';
import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/components/ui/primary_button.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/footer.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/services/api_service.dart';

import 'package:http/http.dart';

const description = "Try us out before becoming a fully";
const link = "Verified Account Holder:";
const notify = "Open your confirmation email and\nclick \"Verify Email\" button at there";

class SignupAlmostPage extends StatefulWidget {
  const SignupAlmostPage({Key? key, this.from, this.email}) : super(key: key);
  final String? from;
  final String? email;

  @override
  State<SignupAlmostPage> createState() => _SignupAlmostPageState();
}

class _SignupAlmostPageState extends State<SignupAlmostPage> {
  bool loading = false;
  
  void onPressedSignin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/wizard/login');
  }

  void onPressedResend(BuildContext context) async {
    if (loading) return;

    setState(() => loading = true);
    String params = jsonEncode(<String, dynamic>{
      'email': widget.email,
    });
    Response? response = await ApiService().post(ApiConstants.reVerify, '', params);
    setState(() => loading = false);

    if (response == null) {
      showDialog(
        context: context, 
        builder: (context) {
          return const ErrorDialog(text: "Please check your network connection");
        }
      );
    } else if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, '/wizard/login');
    }
  }

  List<Widget> decorateBody(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 36.0),
        child: Text("Almost Done!", style: Theme.of(context).textTheme.headline1)
      )
    );
    widgets.add(const Spacer(flex: 1));
    
    if (widget.from == 'login') {
      widgets.add(Text("Please verify your email first.", style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.center));
      widgets.add(const Spacer(flex: 1));
      widgets.add(Text("If you didn't receive the email, please click the below button.", style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.center));
      widgets.add(const Spacer(flex: 1));
      widgets.add(PrimaryButton(loading: loading, buttonText: 'Resend Email', onPressed: () => onPressedResend(context)));
      widgets.add(const Spacer(flex: 1));
    } else {
      widgets.add(Text(description, style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.center));
      widgets.add(
        TextButton(
          onPressed: () {},
          child: Text(link, style: Theme.of(context).textTheme.headline6),
        )
      );
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
          child: Text(
            notify,
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center
          ),
        )
      );
      widgets.add(const Spacer(flex: 1));
      widgets.add(const Dots(selectedIndex: 3, dots: 4));
    }
    widgets.add(
      WizardFooter(
        description: "Do you have an account?",
        buttonText: "Sign in here",
        onPressed: () {
          onPressedSignin(context);
        }
      )
    );
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

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
                          image: AssetImage("assets/images/wizard07.png"))),
                  ),
                  const GradientRectangle()
                ],
              )
            ),
            SizedBox(
              width: deviceSize.width,
              height: 388.0,
              child: Column(children: decorateBody(context))
            )
          ],
        ),
      ),
    );
  }
}
