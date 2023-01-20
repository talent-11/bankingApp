import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/pages/camera/take_picture.dart';

class AppState {
  bool loading;
  String imagePath;

  AppState(this.loading, this.imagePath);
}

class VerifyStep2Page extends StatefulWidget {
  const VerifyStep2Page({Key? key}) : super(key: key);

  @override
  State<VerifyStep2Page> createState() => _VerifyStep2PageState();
}

class _VerifyStep2PageState extends State<VerifyStep2Page> {
  final app = AppState(false, "");

  void onPressedTakePicture(BuildContext context) async {
    await availableCameras().then((cameras) => 
      // Navigator.push(context, MaterialPageRoute(builder: (_) => TakePictureScreen(cameras: cameras))));
      Navigator.push(context, MaterialPageRoute(builder: (_) => 
        TakePictureScreen(camera: cameras.first, action: () { onPressedUpload(context); }, folder: Folders.masterCards))));
  }

  void onPressedUpload(BuildContext context) {
    Navigator.pushNamed(context, '/wizard/signup/agree');
  }

  void onPressedCancel(BuildContext context) {
    Navigator.pop(context);
  }
  
  Widget footer(BuildContext context) => Column(
    children: const [
      Dots(selectedIndex: 3, dots: 6),
    ],
  );

  List<Widget> decorateBody(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(const LogoBar());
    widgets.add(
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please take your I.D./Passport/Driver License picture.",
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 48,
                      child: FotocButton(
                        outline: true,
                        buttonText: "Cancel",
                        onPressed: () {
                          onPressedCancel(context);
                        },
                      ),
                    )
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 48,
                      child: FotocButton(
                        buttonText: "Take a picture",
                        onPressed: () {
                          onPressedTakePicture(context);
                        },
                      ),
                    )
                  ),
                ]
              ),
            ),
          ]
        ),
      )
    );
    widgets.add(footer(context));
    return widgets;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: decorateBody(context),
      ),
    );
  }
}
