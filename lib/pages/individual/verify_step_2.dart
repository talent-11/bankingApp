import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/error_dialog.dart';
import 'package:fotoc/components/ui/radio_text.dart';
import 'package:fotoc/pages/camera/display_picture.dart';
import 'package:fotoc/pages/wizard/signup_agree.dart';
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
  int _step = 0;
  String _cardType = "";
  String _uploadedPictureType = "";
  late XFile _image;

  Future<void> checkCard(BuildContext context) async {
    if (_loading) return;

    setState(() => _loading = true);

    AccountModel me = Provider.of<AccountProvider>(context, listen: false).account;
    String filename = Provider.of<AccountProvider>(context, listen: false).uploadedFilename;
    String folder = _cardType == CardType.idFull ? CardType.id : _cardType == CardType.dlFull ? CardType.dl : CardType.pt;

    String params = jsonEncode(<String, dynamic>{
      // 'file': 'XkuvsPnR.jpg',   // test code
      'file': filename,
      'card_type': folder
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
        if (_step == 0) {
          setState(() {
            _step = 1;
            _uploadedPictureType = _cardType;
            _cardType = "";
            _loading = false;
          });
          Navigator.of(context).pop();
        } else {
          await ApiService().post(ApiConstants.upgrade, me.token, "");
          // Response? res = await ApiService().post(ApiConstants.upgrade, me.token, "");
          // dynamic result = json.decode(res!.body);
          // AccountModel user = AccountModel.fromJson(result['me']);
          // user.token = me.token;
          // context.read<AccountProvider>().setAccount(user);

          setState(() => _loading = false);

          int count = 0;
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SignupAgreePage()), (route) {
            return count ++ == 2;
          });
        }
      } else {
        Navigator.of(context).pop();
        String error = "";
        if (errors[0] == 'card') {
          error = "Seems like you are using fake picture. Please use another or a clearer one.";
        } else if (errors.length == 2) {
          error = "Failed to fetch information from provided image. Please use a clearer one.";
        } else {
          error = (errors[0] == 'name' ? "Your Name" : "Your Birthdate") + " doesn't match. Please user another image.";
        }
        setState(() => _loading = false);
        showDialog(
          context: context, 
          builder: (context) {
            return ErrorDialog(text: error);
          }
        );
      }
    }
  }

  Future<void> uploadFile(BuildContext context) async {
    if (_loading) return;

    AccountModel me = Provider.of<AccountProvider>(context, listen: false).account;

    setState(() { _loading = true; });
    String folder = _cardType == CardType.idFull ? Folders.idCard : _cardType == CardType.dlFull ? Folders.dlCard : Folders.ptCard;
    StreamedResponse? response = await ApiService().uploadFile(me.token!, _image.path, foldername: folder);
    setState(() { _loading = false; });

    if (response!.statusCode == 200) {
      String respStr = await response.stream.bytesToString();
      dynamic result = json.decode(respStr);
      context.read<AccountProvider>().setUploadedFilename(result['filename']);
      checkCard(context);
    }
  }

  void onPressedTakePicture(BuildContext context) async {
    if (_cardType == "") {
      showDialog(
        context: context, 
        builder: (context) {
          String text = "Please choose a card type";
          return ErrorDialog(text: text);
        }
      );
      return;
    }
    String folder = _cardType == CardType.idFull ? Folders.idCard : _cardType == CardType.dlFull ? Folders.dlCard : Folders.ptCard;
    await availableCameras().then((cameras) => 
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (_) => TakePictureScreen(
            camera: cameras.first, 
            action: () { onPressedUpload(context); }, 
            folder: folder
          )
        )
      )
    );
  }

  void onPressedTakeGallery(BuildContext context) async {
    if (_cardType == "") {
      showDialog(
        context: context, 
        builder: (context) {
          String text = "Please choose a card type";
          return ErrorDialog(text: text);
        }
      );
      return;
    }
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
            action: () async {
              await uploadFile(context);
            }
          ),
        ),
      );
    }
  }

  void onPressedUpload(BuildContext context) async {
    checkCard(context);
  }

  void onPressedCancel(BuildContext context) {
    Navigator.pop(context);
  }
  
  Widget footer(BuildContext context) => Column(
    children: const [
      Dots(selectedIndex: 3, dots: 6),
    ],
  );

  Widget radio(String label) => SizedBox(
    width: 160,
    height: 28, 
    child: RadioText(
      disabled: _uploadedPictureType == label,
      label: label,
      textColor: _uploadedPictureType == label ? null : const Color(0xff252631),
      groupValue: _cardType,
      onChanged: (value) {
        setState(() { _cardType = value.toString(); });
      }
    ),
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
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Choose your " + (_step == 0 ? "first" : "second") + " picture.",
              style: const TextStyle(color: Color(0xff252631), fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            radio(CardType.idFull),
            radio(CardType.dlFull),
            radio(CardType.ptFull),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
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
