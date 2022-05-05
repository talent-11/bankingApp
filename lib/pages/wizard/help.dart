import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/bullet_row.dart';
import 'package:fotoc/components/wizard/text_with_cc.dart';
import 'package:fotoc/pages/wizard/sidebar.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  void onPressedBack(BuildContext context) {
    Navigator.pop(context);
  }

  IconButton backButton(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back_ios, size: 32.0),
    onPressed: () => onPressedBack(context), 
    color: Colors.white,
  );

  Padding commonRow(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextWithCC(text: text)
  );

  Widget bulletRow(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: BulletRow(text: text),
  );

  Widget body(BuildContext context) => Expanded(
    flex: 1,
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      children: [
        bulletRow(context, "Not sure about us? We’ll give you {{s}}100 to spend, just for verifying your email address. Try us out before opening an account."),
        bulletRow(context, "Ready to open an account? A fully Verified Account Holder (V.A.H) receives {{s}}10,000."),
        bulletRow(context, "We will match your personal funds from other currency systems. V.A.H’s who provide current bank statement(s) will receive matching funds into their account at FOTOC Bank. This is a onetime matching of funds: Value = \$ Dollar for {{s}} CC. Current exchange rate to convert currencies not based on the Dollar.\n{{uExample}}: If you have the equivalent of \$100,000 in a FRB system Bank (typical Bank) account or crypto currency bank account, we will match that amount: we will transfer {{s}}100,000 into your account at FOTOC Bank."),
        bulletRow(context, "We will match a Verified Business Account holder’s (V.B.A.H) funds from other currency systems. V.B.A.H’s have the choice between (1) receiving current matching funds into their account at FOTOC Bank or (2) 10% of their net annual sales, whichever is greater (any verified year end bank statement(s), 2019, 2020 or 2021 will be accepted). This is a onetime matching of funds: Value = \$ Dollar for {{s}} CC. Current exchange rate to convert currencies not based on the Dollar.\n{{uExample}}: (1) If you currently have the equivalent of \$100,000 in a FRB system Bank (typical bank) account or a crypto currency account, we will match that amount: we will transfer {{s}}100,000 into your account at FOTOC Bank or (2) if you submit a verifiable year end bank statement(s) (2019, 2020 or 2021 accepted) showing that you had \$3,000,000 annual sales for that year, you will receive 10% ({{s}}300,000). We will transfer {{s}}300,000 into your business account at FOTOC Bank."),
        bulletRow(context, "Refer someone: V.A.H will receive {{s}}1,000 after someone opens a new verified account and enters in your unique referral number in the “Who referred you?” section during the sign up/account verification process."),
        bulletRow(context, "Buyers will receive 5% cash back on all transactions done through FOTOC Bank."),
        bulletRow(context, "Two types of accounts available for customers; a savings account and a transaction account."),
        bulletRow(context, "Savings Accounts for minors available: (under age of 16) must have a parent or guardian as joint owner on the account until 18 years old."),
        bulletRow(context, "Transaction accounts available (ages 16 and 17) must have a parent or guardian as joint owner on the account."),
        bulletRow(context, "All Savings Accounts – receive 6% annual interest paid monthly (based on daily average in account)."),
        bulletRow(context, "All Savings Accounts through banks chartered and authorized under FOTOC Bank – will receive an additional 2% annual interest paid monthly (based on daily average in account)."),
        bulletRow(context, "U.S.A. Senior Citizens V.A.H’s (65 yrs old +) will receive {{s}}3,000 per month (See: {{cBenefits and Retirement}}). Surviving Spouse Benefit: If one spouse passes away (Limited to 1 spouse) – surviving spouse will receive deceased spouse’s {{s}}3,000 monthly benefit until they pass away- then both benefits end. Loss of deceased spouse’s benefit upon remarriage."),
        commonRow(context, "FOTOC Bank is available to anyone throughout the world. Buy and sell with anyone who accepts {{s}} CC’s and has a verified account with FOTOC Bank. Review our Terms of Service for more information."),
        commonRow(context, "© 2022 Friends of the Original Constitution is the interim Constitutional Government. FOTOC Bank is the Citizen owned Central Bank, authorized by We the People; by our signatures on the Declaration of Restoration, by the original Constitution (Article 1 Section 8) and by the Constitutional Convention & Court (CC&C); whose purpose is to restore the Constitutional Government."),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SideBar(),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            LogoBar(iconButton: backButton(context)),
            body(context)
          ],
        ),
      ),
    );
  }
}
