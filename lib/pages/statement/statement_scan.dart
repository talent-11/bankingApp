import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/models/statement_model.dart';
import 'package:fotoc/pages/camera/take_picture.dart';
import 'package:fotoc/pages/statement/statement_preview.dart';
import 'package:fotoc/providers/statement_provider.dart';

import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';


class StatementScanPage extends StatefulWidget {
  const StatementScanPage({Key? key}) : super(key: key);

  @override
  State<StatementScanPage> createState() => _StatementScanPageState();
}

class _StatementScanPageState extends State<StatementScanPage> {
  StatementModel? _statement;
  
  @override
  void initState() {
    super.initState();

    StatementModel statement = Provider.of<CurrentStatement>(context, listen: false).statement;
    setState(() { _statement = statement; });
  }

  void onPressedTakePicture(BuildContext context) async {
    await availableCameras().then((cameras) => 
      Navigator.push(context, MaterialPageRoute(builder: (_) => 
        TakePictureScreen(camera: cameras.first, action: () { onPressedUpload(context); }, folder: Folders.statements))));
  }

  void onPressedUpload(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const StatementPreviewPage()));
  }

  void onPressedCancel(BuildContext context) {
    Navigator.pop(context);
    // Navigator.popUntil(context, (route) => route.isFirst);
  }
  
  Widget decorateItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 132,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xff252631),
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xff98a9bc),
              fontSize: 14,
            ),
          )
        ],
      )
    );
  }

  List<Widget> decorateBody(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(const LogoBar());
    widgets.add(
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: decorateItem(context, "Bank Name", _statement!.bankName!),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: decorateItem(context, "Full Name", _statement!.name!),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: decorateItem(context, "Ending Balance", "\$" + _statement!.balance!.toString()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: decorateItem(context, "Issued Year", _statement!.year!.toString()),
            ),
            const SizedBox(height: 20),
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
