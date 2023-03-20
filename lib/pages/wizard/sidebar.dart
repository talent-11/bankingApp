import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fotoc/components/ui/confirm_dialog.dart';
import 'package:fotoc/pages/wizard/help.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  TextStyle textStyle(BuildContext context) => TextStyle(color: Theme.of(context).primaryColor);

  void onPressedMenuItem(BuildContext context, String kind) {
    Navigator.of(context).pop();
    switch(kind) {
      case 'help':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpPage()));
        break;
      default:
        break;
    }
  }

  void onPressedExit(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context) {
        String text = "Are you sure you want to exit app and log off?";
        return ConfirmDialog(text: text, onPressedYes: () => exit(0), onPressedNo: () => Navigator.of(context).pop(),);
      }
    );
    // exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 176.0,
            child: DrawerHeader(
              child: Center(
                child: SvgPicture.asset(
                  "assets/svgs/logo.svg",
                  width: 118,
                  height: 120,
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.help, color: Theme.of(context).primaryColor),
            title: Text('Help', style: textStyle(context)),
            onTap: () => onPressedMenuItem(context, 'help'),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.question_answer, color: Theme.of(context).primaryColor),
            title: Text('FAQ', style: textStyle(context)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.group, color: Theme.of(context).primaryColor),
            title: Text('About Us', style: textStyle(context)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.note_alt, color: Theme.of(context).primaryColor),
            title: Text('Terms & Conditions', style: textStyle(context)),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Theme.of(context).primaryColor),
            title: Text('Exit', style: textStyle(context)),
            onTap: () => onPressedExit(context),
          ),
        ],
      ),
    );
  }
}
