import 'package:flutter/material.dart';
import 'package:fotoc/components/gradient_rectangle.dart';
import 'package:fotoc/components/primary_button.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/footer.dart';
import 'package:fotoc/components/wizard/labeled_checkbox.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';

class Signup3Page extends StatefulWidget {
  const Signup3Page({Key? key}) : super(key: key);

  @override
  State<Signup3Page> createState() => _Signup3PageState();
}

class _Signup3PageState extends State<Signup3Page> {
  bool agreed = false;

  void onPressedNext(BuildContext context) {
    Navigator.pushNamed(context, '/wizard/signup/3');
  }

  void onPressedSignin(BuildContext context) {
    Navigator.pushNamed(context, '/');
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
                              image: AssetImage("assets/images/wizard06.png"))),
                    ),
                    const GradientRectangle()
                  ],
                )),
            SizedBox(
                width: deviceSize.width,
                height: 510,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 34.0),
                        child: Text("Account details",
                            style: Theme.of(context).textTheme.headline1)),
                    const Padding(
                        padding: EdgeInsets.only(top: 24.0),
                        child: TextInputField(
                          labelText: "Your name",
                          hintText: "Enter your full name",
                        )),
                    const Padding(
                        padding: EdgeInsets.only(top: 14.0),
                        child: TextInputField(
                          labelText: "Your account",
                          hintText: "Enter your email or phone",
                        )),
                    const Padding(
                        padding: EdgeInsets.only(top: 14.0),
                        child: TextInputField(
                          labelText: "Create password",
                          hintText: "Enter your password",
                        )),
                    const Spacer(flex: 1),
                    Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 20.0),
                        child: LabeledCheckbox(
                            labelText: "I agree with terms & conditions",
                            checked: agreed,
                            valueChanged: (bool? value) {
                              setState(() {
                                agreed = value!;
                              });
                            })),
                    const Spacer(flex: 1),
                    PrimaryButton(
                        buttonText: "NEXT",
                        onPressed: () {
                          onPressedNext(context);
                        }),
                    const Dots(
                      selectedIndex: 1.0,
                    ),
                    WizardFooter(
                        description: "Do you have an account?",
                        buttonText: "Sign in here",
                        onPressed: () {
                          onPressedSignin(context);
                        })
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
