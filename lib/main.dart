import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fotoc/pages/wallet/wallet_tabs.dart';
import 'package:fotoc/pages/wizard/forgot_password.dart';
import 'package:fotoc/pages/wizard/help.dart';
import 'package:fotoc/pages/wizard/welcome.dart';
import 'pages/wizard/signup_start.dart';
import 'pages/wizard/signup_step_2.dart';
import 'pages/wizard/signup_main.dart';
import 'pages/wizard/signup_almost.dart';
import 'pages/wizard/login.dart';
// import 'pages/wizard/login_with_finger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FOTOC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // brightness: Brightness.dark,
        primaryColor: const Color(0xff5d10f6),
        fontFamily: 'Roboto',
        // primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 20.0,
            color: Color(0xff252631),
            fontWeight: FontWeight.w400
          ),
          headline4: TextStyle(
            fontSize: 14.0, 
            color: Colors.white, 
            fontWeight: FontWeight.w500
          ),
          headline5: TextStyle(
            fontSize: 15.0,
            height: 1.4,
            color: Color(0xff252631),
            fontWeight: FontWeight.w400
          ),
          headline6: TextStyle(
            fontSize: 14.0,
            color: Color(0xff252631),
            fontWeight: FontWeight.w500
          ),
          bodyText1: TextStyle(fontSize: 14.0, color: Color(0xff98a9bc), height: 1.4),
          bodyText2: TextStyle(fontSize: 12.0, color: Color(0xff98a9bc), height: 1.2),
        ),
        textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Color(0xff5d10f6)),
      ),
      // home: const SignupPage(),
      routes: {
        '/': (context) => const SignupStartPage(),
        '/wizard/welcome': (context) => const WelcomePage(),
        '/wizard/help': (context) => const HelpPage(),
        // '/wizard/login/fingerprint': (context) => const LoginWithFingerPage(),
        '/wizard/login': (context) => const LoginPage(),
        '/wizard/recover': (context) => const ForgotPasswordPage(),
        '/wizard/signup': (context) => const SignupStartPage(),
        '/wizard/signup/1': (context) => const Signup2Page(),
        '/wizard/signup/main': (context) => const SignupMainPage(),
        '/wizard/signup/almost': (context) => const SignupAlmostPage(),
        '/wallet': (context) => const WalletTabsPage(),
      },
    );
  }
}
