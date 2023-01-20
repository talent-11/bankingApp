import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:http/http.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String actionText;
  final Function action;

  const DisplayPictureScreen({Key? key, required this.imagePath, required this.actionText, required this.action}) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {

  void retake() {
    Navigator.of(context).pop();
  }

  List<Widget> decorateBody(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(
      const Padding(
        padding: EdgeInsets.only(bottom: 16.0), 
        child: LogoBar()
      )
    );
    widgets.add(
      Expanded(
        child: Image.file(File(widget.imagePath)),
      )
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.all(16), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 48.0,
                child: FotocButton(
                  outline: true,
                  buttonText: "Cancel",
                  onPressed: retake,
                )
              )
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 48.0,
                child: FotocButton(
                  buttonText: widget.actionText,
                  onPressed: widget.action,
                )
              )
            ),
          ],
        )
      )
    );
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: decorateBody(context),
      ),
    );
  }
}