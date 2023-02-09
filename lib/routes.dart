import 'package:flutter/cupertino.dart';
import 'package:fotoc/pages/dashboard/dashboard.dart';
import 'package:fotoc/pages/individual/verify_step_3.dart';
import 'package:fotoc/pages/statement/statement_about_cash.dart';
import 'package:fotoc/pages/wallet/wallet_tabs.dart';
import 'package:fotoc/pages/wizard/forgot_password.dart';
import 'package:fotoc/pages/wizard/help.dart';
import 'package:fotoc/pages/wizard/login.dart';
import 'package:fotoc/pages/wizard/signup_agree.dart';
import 'package:fotoc/pages/wizard/signup_start.dart';
import 'package:fotoc/pages/wizard/welcome.dart';
import 'package:fotoc/pages/statement/statement_Information.dart';

final routes = {
  '/': (BuildContext context) => const WelcomePage(),
  '/wizard/welcome': (BuildContext context) => const WelcomePage(),
  '/wizard/help': (BuildContext context) => const HelpPage(),
  '/wizard/login': (BuildContext context) => const LoginPage(),
  '/wizard/recover': (BuildContext context) => const ForgotPasswordPage(),
  '/wizard/signup/agree': (BuildContext context) => const SignupAgreePage(),
  '/wizard/signup/start': (BuildContext context) => const SignupStartPage(),
  '/free/main': (BuildContext context) => const MainTabsPage(),
  '/free/dashboard': (BuildContext context) => const DashboardPage(),
  '/free/verify/3': (BuildContext context) => const VerifyStep3Page(),
  '/statement/information': (BuildContext context) => const StatementInformationPage(),
  '/statement/about-cash': (BuildContext context) => const StatementAboutCashPage(),
};