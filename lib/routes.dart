import 'package:flutter/cupertino.dart';
import 'package:fotoc/pages/dashboard/dashboard.dart';
import 'package:fotoc/pages/individual/verify_step_0.dart';
import 'package:fotoc/pages/individual/verify_step_1.dart';
import 'package:fotoc/pages/individual/verify_step_2.dart';
import 'package:fotoc/pages/individual/verify_step_3.dart';
import 'package:fotoc/pages/individual/verify_step_need.dart';
import 'package:fotoc/pages/statement/statement_about_cash.dart';
import 'package:fotoc/pages/wallet/wallet_tabs.dart';
import 'package:fotoc/pages/wizard/forgot_password.dart';
import 'package:fotoc/pages/wizard/help.dart';
import 'package:fotoc/pages/wizard/login.dart';
import 'package:fotoc/pages/wizard/signup_agree.dart';
import 'package:fotoc/pages/wizard/signup_start.dart';
import 'package:fotoc/pages/wizard/signup_almost.dart';
import 'package:fotoc/pages/wizard/signup_main.dart';
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
  '/wizard/signup/main': (BuildContext context) => const SignupMainPage(),
  '/wizard/signup/almost': (BuildContext context) => const SignupAlmostPage(),
  '/free/main': (BuildContext context) => const MainTabsPage(),
  '/free/dashboard': (BuildContext context) => const DashboardPage(),
  '/free/verify/0': (BuildContext context) => const VerifyStep0Page(),
  '/free/verify/need': (BuildContext context) => const VerifyStepNeedPage(),
  '/free/verify/1': (BuildContext context) => const VerifyStep1Page(),
  '/free/verify/2': (BuildContext context) => const VerifyStep2Page(),
  '/free/verify/3': (BuildContext context) => const VerifyStep3Page(),
  '/statement/information': (BuildContext context) => const StatementInformationPage(),
  '/statement/about-cash': (BuildContext context) => const StatementAboutCashPage(),
};