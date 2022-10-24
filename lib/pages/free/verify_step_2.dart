import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/ui/primary_button.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/pages/camera/take_picture.dart';

class AppState {
  bool loading;
  String imagePath;
  int step;

  AppState(this.loading, this.imagePath, this.step);
}

class VerifyStep2Page extends StatefulWidget {
  const VerifyStep2Page({Key? key}) : super(key: key);

  @override
  State<VerifyStep2Page> createState() => _VerifyStep2PageState();
}

class _VerifyStep2PageState extends State<VerifyStep2Page> {
  final app = AppState(false, "", 0);

  void uploadImage() {

  }

  void onPressedTakePicture(BuildContext context) async {
    await availableCameras().then((cameras) => 
      // Navigator.push(context, MaterialPageRoute(builder: (_) => TakePictureScreen(cameras: cameras))));
      Navigator.push(context, MaterialPageRoute(builder: (_) => 
        TakePictureScreen(camera: cameras.first, action: () { onPressedUpload(context); },))));
  }

  void onPressedUpload(BuildContext context) {
    Navigator.pushNamed(context, '/free/verify/3');
  }
  
  Widget footer(BuildContext context) => Column(
    children: const [
      Dots(selectedIndex: 1),
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
              padding: const EdgeInsets.only(top: 40.0),
              child: PrimaryButton(
                buttonText: "Take a picture",
                onPressed: () {
                  onPressedTakePicture(context);
                }
              ),
            )
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