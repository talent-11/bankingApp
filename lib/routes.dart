import 'package:flutter/cupertino.dart';
import 'package:fotoc/pages/dashboard/dashboard.dart';
import 'package:fotoc/pages/statement/statement_about_cash.dart';
import 'package:fotoc/pages/wizard/forgot_password.dart';
import 'package:fotoc/pages/wizard/help.dart';
import 'package:fotoc/pages/wizard/welcome.dart';
import 'package:fotoc/pages/statement/statement_Information.dart';

final routes = {
  '/': (BuildContext context) => const WelcomePage(),
  '/wizard/welcome': (BuildContext context) => const WelcomePage(),
  '/wizard/help': (BuildContext context) => const HelpPage(),
  '/wizard/recover': (BuildContext context) => const ForgotPasswordPage(),
  '/free/dashboard': (BuildContext context) => const DashboardPage(),
  '/statement/information': (BuildContext context) => const StatementInformationPage(),
  '/statement/about-cash': (BuildContext context) => const StatementAboutCashPage(),
};