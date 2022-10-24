import 'package:flutter/material.dart';
import 'package:fotoc/components/gradient_rectangle.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/footer.dart';

const description = "Review";
const link = "Verified Account Holder:";
const notify = "We are reviewing your profile. Please wait 3 business days.";

class VerifyStep3Page extends StatefulWidget {
  const VerifyStep3Page({Key? key}) : super(key: key);

  @override
  State<VerifyStep3Page> createState() => _VerifyStep3PageState();
}

class _VerifyStep3PageState extends State<VerifyStep3Page> {
  void onPressedHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/free/dashboard');
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
                )),
            SizedBox(
                width: deviceSize.width,
                height: 388.0,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 36.0),
                      child: Text("Almost Done!", style: Theme.of(context).textTheme.headline1)),
                    const Spacer(flex: 1),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
                      child: Text(
                        notify,
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center),
                    ),
                    const Spacer(flex: 1),
                    const Dots(
                      selectedIndex: 2.0,
                    ),
                    WizardFooter(
                      description: "",
                      buttonText: "Go to home page",
                      onPressed: () {
                        onPressedHome(context);
                      })
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
