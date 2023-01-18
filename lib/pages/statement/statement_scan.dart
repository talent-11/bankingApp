import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/pages/camera/take_picture.dart';
import 'package:fotoc/pages/statement/statement_preview.dart';

class StatementScanPage extends StatefulWidget {
  const StatementScanPage({Key? key}) : super(key: key);

  @override
  State<StatementScanPage> createState() => _StatementScanPageState();
}

class _StatementScanPageState extends State<StatementScanPage> {
  void uploadImage() {

  }

  void onPressedTakePicture(BuildContext context) async {
    await availableCameras().then((cameras) => 
      Navigator.push(context, MaterialPageRoute(builder: (_) => 
        TakePictureScreen(camera: cameras.first, action: () { onPressedUpload(context); }))));
  }

  void onPressedUpload(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const StatementPreviewPage()));
  }

  void onPressedCancel(BuildContext context) {
    // Navigator.pop(context);
    Navigator.popUntil(context, (route) => route.isFirst);
  }
  
  List<Widget> decorateBody(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(const LogoBar());
    widgets.add(
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please take your bank statement picture.",
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
