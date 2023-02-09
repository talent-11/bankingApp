import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';

import 'package:fotoc/components/ui/primary_button.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/text_input_field.dart';
import 'package:fotoc/pages/business/business_verify_3.dart';
import 'package:fotoc/services/validation_service.dart';

class BusinessVerify2Page extends StatefulWidget {
  const BusinessVerify2Page({Key? key}) : super(key: key);

  @override
  State<BusinessVerify2Page> createState() => _BusinessVerify2PageState();
}

class _BusinessVerify2PageState extends State<BusinessVerify2Page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _tax, _name, _email, _suite, _city, _state, _country = 'US';

  void onPressedBack(BuildContext context) {
    Navigator.pop(context);
  }

  void onPressedNext(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (_) => BusinessVerify3Page(
            tax: _tax,
            email: _email,
            name: _name,
            suite: _suite,
            city: _city,
            state: _state,
            country: _country,
          )
        )
      );
    }
  }
  
  IconButton backButton(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back_ios, size: 32.0),
    onPressed: () => onPressedBack(context), 
    color: Colors.white,
  );

  List<Widget> decorateBody(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 24.0, bottom: 16),
        child: Text(
          "Business details",
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: TextInputField(
          hintText: "Tax ID Number",
          onChanged: (val) { setState(() => _tax = val!); },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your tax ID number';
            }
            return null;
          },
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: TextInputField(
          keyboardType: TextInputType.emailAddress,
          hintText: "Business Email",
          onChanged: (val) { setState(() => _email = val!); },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter email';
            } else if (!value.isValidEmail) {
              return 'Please enter valid email';
            }
            return null;
          },
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: TextInputField(
          keyboardType: TextInputType.name,
          hintText: "Business Name",
          onChanged: (val) { setState(() => _name = val!); },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your business name';
            }
            return null;
          },
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextInputField(
          hintText: "Enter your house number and street name",
          onChanged: (val) {
            setState(() => _suite = val!);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your address';
            }
            return null;
          },
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextInputField(
          hintText: "Enter your city",
          onChanged: (val) {
            setState(() => _city = val!);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your city';
            }
            return null;
          },
        )
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextInputField(
          hintText: "Enter your state or province",
          onChanged: (val) {
            setState(() => _state = val!);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your state or province';
            }
            return null;
          },
        )
      )
    );
    widgets.add(
      CountryListPick(
        appBar: AppBar(backgroundColor: Theme.of(context).primaryColor, title: const Text('Select your country')),
        
        pickerBuilder: (context, CountryCode? countryCode) {
          String code = "", flagUrl = "";

          if (countryCode != null) {
            code = countryCode.name!;
            flagUrl = countryCode.flagUri!;
          }

          return Container(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffe8ecef), width: 1.0))),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Image.asset(flagUrl, package: 'country_list_pick', height: 14, fit: BoxFit.fitHeight),
                  ),
                  Expanded(child: Text(code, style: Theme.of(context).textTheme.headline6)),
                  Icon(Icons.arrow_drop_down, size: 20, color: Theme.of(context).primaryColor),
                ],
              ),
            )
          );
        },

        // To disable option set to false
        theme: CountryTheme(
          labelColor: const Color(0xff98a9bc),
          showEnglishName: true,
        ),
        // Set default value
        initialSelection: _country,
        onChanged: (countryCode) => _country = countryCode!.code!,
        // Whether to allow the widget to set a custom UI overlay
        useUiOverlay: true,
        // Whether the country list should be wrapped in a SafeArea
        useSafeArea: true
      ),
    );
    widgets.add(const SizedBox(height: 16.0));
    return widgets;
  }

  List<Widget> decorateFooter(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(PrimaryButton(buttonText: "NEXT", onPressed: () { onPressedNext(context); }));
    widgets.add(const Dots(selectedIndex: 1, dots: 6));
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LogoBar(iconButton: backButton(context)),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: decorateBody(context),
                )
              )
            )
          ),
          Column(children: decorateFooter(context)),
        ],
      ),
    );
  }
}
