import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/pages/camera/display_picture.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/constants.dart';
import 'package:fotoc/pages/camera/take_picture.dart';
import 'package:fotoc/services/api_service.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/providers/account_provider.dart';

class VerifyStep2Page extends StatefulWidget {
  const VerifyStep2Page({Key? key}) : super(key: key);

  @override
  State<VerifyStep2Page> createState() => _VerifyStep2PageState();
}

class _VerifyStep2PageState extends State<VerifyStep2Page> {
  bool _loading = false;
  late XFile _image;

  Future<void> uploadFile(BuildContext context) async {
    if (_loading) return;

    AccountModel me = Provider.of<CurrentAccount>(context, listen: false).account;

    setState(() { _loading = true; });
    StreamedResponse? response = await ApiService().uploadFile(me.token!, _image.path, foldername: Folders.masterCards);
    setState(() { _loading = false; });
    if (response!.statusCode == 200) {
      String respStr = await response.stream.bytesToString();
      dynamic result = json.decode(respStr);
      context.read<CurrentAccount>().setUploadedFilename(result['filename']);
      Navigator.pushNamed(context, '/wizard/signup/agree');
    }
  }

  void onPressedTakePicture(BuildContext context) async {
    await availableCameras().then((cameras) => 
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (_) => TakePictureScreen(
            camera: cameras.first, 
            action: () { onPressedUpload(context); }, folder: Folders.masterCards
          )
        )
      )
    );
  }

  void onPressedTakeGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() { _image = image; });
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            // Pass the automatically generated path to
            // the DisplayPictureScreen widget.
            imagePath: image.path,
            actionText: "Upload",
            action: () {
              uploadFile(context);
            }
          ),
        ),
      );
    }
  }

  void onPressedUpload(BuildContext context) async {
    if (_loading) return;

    setState(() => _loading = true);

    AccountModel me = Provider.of<CurrentAccount>(context, listen: false).account;
    String filename = Provider.of<CurrentAccount>(context, listen: false).uploadedFilename;
    
    String params = jsonEncode(<String, dynamic>{
      // 'file': 'XkuvsPnR.jpg',   // test code
      'file': filename,
    });
    Response? response = await ApiService().post(ApiConstants.ocrIdCard, me.token, params);
    
    if (response == null) {
      setState(() => _loading = false);
      showDialog(
        context: context, 
        builder: (context) {
          String text = "Please check your internet";
          return ErrorDialog(text: text);
        }
      );
      return;
    }
    
    dynamic res = json.decode(response.body);
    if (response.statusCode == 200) {
      List<dynamic> errors = res["error_types"];

      if (errors.isEmpty) {
        Response? res = await ApiService().post(ApiConstants.upgrade, me.token, "");
        dynamic result = json.decode(res!.body);
        AccountModel user = AccountModel.fromJson(result['me']);
        user.token = me.token;
        context.read<CurrentAccount>().setAccount(user);

        setState(() => _loading = false);

        Navigator.pushNamed(context, '/wizard/signup/agree');
      } else {
        setState(() => _loading = false);
        showDialog(
          context: context, 
          builder: (context) {
            String text = "Please use more clear picture";
            return ErrorDialog(text: text);
          }
        );
      }
    }
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
                      height: 40,
                      child: FotocButton(
                        buttonText: "Camera",
                        onPressed: () {
                          onPressedTakePicture(context);
                        },
                      ),
                    )
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 40,
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
                      height: 40,
                      child: FotocButton(
                        buttonText: "Gallery",
                        onPressed: () {
                          onPressedTakeGallery(context);
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