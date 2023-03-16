import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fotoc/models/account_model.dart';
import 'package:fotoc/pages/camera/display_picture.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/services/api_service.dart';

import 'package:http/http.dart';
import 'package:provider/provider.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({Key? key, required this.camera, required this.action, this.folder = ""}) : super(key: key);
  
  final CameraDescription camera;
  final Function action;
  final String folder;

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late XFile _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    initCamera(widget.camera);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Future<void> onPressedUpload(BuildContext context) async {
    if (_loading) return;

    AccountModel me = Provider.of<AccountProvider>(context, listen: false).account;

    setState(() { _loading = true; });
    StreamedResponse? response = await ApiService().uploadFile(me.token!, _image.path, foldername: widget.folder);
    setState(() { _loading = false; });
    if (response!.statusCode == 200) {
      String respStr = await response.stream.bytesToString();
      dynamic result = json.decode(respStr);
      context.read<AccountProvider>().setUploadedFilename(result['filename']);
      // context.read<CurrentAccount>().setUploadedFilename('AmericanExpressNationalBank.jpg');
      widget.action();
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(cameraDescription, ResolutionPreset.high);

    try {
      await _controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  Future takePicture() async {
    if (!_controller.value.isInitialized) {
      return null;
    }

    if (_controller.value.isTakingPicture) {
      return null;
    }
    
    try {
      await _controller.setFlashMode(FlashMode.off);

      XFile image = await _controller.takePicture();
      setState(() { _image = image; });

      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            // Pass the automatically generated path to
            // the DisplayPictureScreen widget.
            imagePath: image.path,
            actionText: "Upload",
            action: () {
              onPressedUpload(context);
            }
          ),
        ),
      );
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        // title: const Text('Take a picture')
      ),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Center(
        child: 
          (_controller.value.isInitialized)
            ? CameraPreview(_controller)
            : Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator())
              )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        // Provide an onPressed callback.
        onPressed: takePicture,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
