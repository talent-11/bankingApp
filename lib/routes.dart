import 'package:flutter/cupertino.dart';
import 'package:fotoc/pages/free/free_dashboard.dart';
import 'package:fotoc/pages/wallet/wallet_tabs.dart';
import 'package:fotoc/pages/wizard/forgot_password.dart';
import 'package:fotoc/pages/wizard/help.dart';
import 'package:fotoc/pages/wizard/login.dart';
import 'package:fotoc/pages/wizard/signup_almost.dart';
import 'package:fotoc/pages/wizard/signup_main.dart';
import 'package:fotoc/pages/wizard/signup_start.dart';
import 'package:fotoc/pages/wizard/signup_step_2.dart';
import 'package:fotoc/pages/wizard/welcome.dart';
// import 'pages/wizard/login_with_finger.dart';

final routes = {
  '/': (BuildContext context) => const WelcomePage(),
  '/wizard/welcome': (BuildContext context) => const WelcomePage(),
  '/wizard/help': (BuildContext context) => const HelpPage(),
  // '/wizard/login/fingerprint': (context) => const LoginWithFingerPage(),
  '/wizard/login': (BuildContext context) => const LoginPage(),
  '/wizard/recover': (BuildContext context) => const ForgotPasswordPage(),
  '/wizard/signup': (BuildContext context) => const SignupStartPage(),
  '/wizard/signup/1': (BuildContext context) => const Signup2Page(),
  '/wizard/signup/main': (BuildContext context) => const SignupMainPage(),
  '/wizard/signup/almost': (BuildContext context) => const SignupAlmostPage(),
  '/wallet': (BuildContext context) => const WalletTabsPage(),
  '/free/dashboard': (BuildContext context) => const FreeDashboardPage(),
};