import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fotoc/components/gradient_rectangle.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/pages/statement/statement_information.dart';
import 'package:fotoc/pages/wizard/login.dart';
// import 'package:fotoc/components/wizard/footer.dart';

const description = "Review";
const link = "Verified Account Holder:";
const notify = "We are reviewing your profile. Please wait 3 business days.";

class VerifyStep3Page extends StatefulWidget {
  const VerifyStep3Page({Key? key, required this.from}) : super(key: key);

  final String from;

  @override
  State<VerifyStep3Page> createState() => _VerifyStep3PageState();
}

class _VerifyStep3PageState extends State<VerifyStep3Page> {
  void onPressedYes(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StatementInformationPage()));
  }

  void onPressedLater(BuildContext context) {
    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainTabsPage()), (route) => false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
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
                        image: AssetImage("assets/images/wizard07.png")
                      )
                    ),
                  ),
                  const GradientRectangle()
                ],
              )
            ),
            SizedBox(
              width: deviceSize.width,
              height: 388.0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 36.0),
                    child: Text(
                      "Congratulations! You have successfully opened your verified account.", 
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // const Spacer(flex: 3),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
                  //   child: Text(
                  //     notify,
                  //     style: Theme.of(context).textTheme.headline5,
                  //     textAlign: TextAlign.center),
                  // ),
                  const Spacer(flex: 3),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
                    child: Text(
                      "Do you want to match your funds now?",
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.center),
                  ),
                  const Spacer(flex: 1),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 120,
                          child: FotocButton(
                            buttonText: "Yes",
                            onPressed: () {
                              onPressedYes(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 120,
                          height: 40,
                          child: FotocButton(
                            outline: true,
                            buttonText: "Later",
                            onPressed: () {
                              onPressedLater(context);
                            },
                          ),
                        )
                      ]
                    ),
                  ),
                  const Spacer(flex: 1),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
                    child: RichText(
                      text: TextSpan(
                        text: "Learn More",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () => {
                          onPressedYes(context)
                        },
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  widget.from == Ext.individual ? const Spacer(flex: 1) : const SizedBox(width: 0, height: 0),
                  widget.from == Ext.individual ? const Dots(selectedIndex: 5, dots: 6) : const SizedBox(width: 0, height: 0),
                  // WizardFooter(
                  //   description: "",
                  //   buttonText: "Go to home page",
                  //   onPressed: () {
                  //     onPressedHome(context);
                  //   })
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
