import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fotoc/pages/wizard/forgot_password.dart';
import 'pages/wizard/signup.dart';
import 'pages/wizard/signup_step_2.dart';
import 'pages/wizard/signup_step_3.dart';
import 'pages/wizard/signup_step_4.dart';
import 'pages/wizard/login_with_email.dart';
import 'pages/wizard/login_with_finger.dart';

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
              fontWeight: FontWeight.w400),
          headline4: TextStyle(
              fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.w500),
          headline5: TextStyle(
              fontSize: 15.0,
              color: Color(0xff252631),
              fontWeight: FontWeight.w400),
          headline6: TextStyle(
              fontSize: 14.0,
              color: Color(0xff252631),
              fontWeight: FontWeight.w500),
          bodyText1: TextStyle(fontSize: 14.0, color: Color(0xff98a9bc)),
          bodyText2: TextStyle(fontSize: 12.0, color: Color(0xff98a9bc)),
        ),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Color(0xff5d10f6)),
      ),
      // home: const SignupPage(),
      routes: {
        '/': (context) => const LoginWithFingerPage(),
        '/wizard/login/fingerprint': (context) => const LoginWithFingerPage(),
        '/wizard/login/email': (context) => const LoginWithEmailPage(),
        '/wizard/login/recover': (context) => const ForgotPasswordPage(),
        '/wizard/signup/0': (context) => const SignupPage(),
        '/wizard/signup/1': (context) => const Signup2Page(),
        '/wizard/signup/2': (context) => const Signup3Page(),
        '/wizard/signup/3': (context) => const Signup4Page(),
      },
    );
  }
}
