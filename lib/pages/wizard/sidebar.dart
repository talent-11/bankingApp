import 'package:flutter/material.dart';
import 'dart:io';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  TextStyle textStyle(BuildContext context) => TextStyle(color: Theme.of(context).primaryColor);

  void onPressedMenuItem(BuildContext context, String kind) {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/wizard/$kind');
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
                child: Image.asset("assets/images/logo.png"),
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
            onTap: () => exit(0),
          ),
        ],
      ),
    );
  }
}
