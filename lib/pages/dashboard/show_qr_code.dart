import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShowQrCodeScreen extends StatefulWidget {
  const ShowQrCodeScreen({Key? key, required this.dataString}) : super(key: key);

  final String dataString;

  @override
  State<ShowQrCodeScreen> createState() => _ShowQrCodeScreenState();
}

class _ShowQrCodeScreenState extends State<ShowQrCodeScreen> {

  GlobalKey globalKey = GlobalKey();
  // late String _inputErrorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Generator'),
        backgroundColor: Theme.of(context).primaryColor,
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.share),
        //     onPressed: _captureAndSharePng,
        //   )
        // ],
      ),
      body: _contentWidget(),
    );
  }

  // Future<void> _captureAndSharePng() async {
  //   try {
  //     RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
  //     var image = await boundary.toImage();
  //     ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
  //     Uint8List pngBytes = byteData.buffer.asUint8List();

  //     final tempDir = await getTemporaryDirectory();
  //     final file = await new File('${tempDir.path}/image.png').create();
  //     await file.writeAsBytes(pngBytes);

  //     final channel = const MethodChannel('channel:me.alfian.share/share');
  //     channel.invokeMethod('shareFile', 'image.png');

  //   } catch(e) {
  //     print(e.toString());
  //   }
  // }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return  Container(
      color: const Color(0xFFFFFFFF),
      child:  Column(
        children: <Widget>[
          Expanded(
            child:  Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: widget.dataString,
                  size: 0.5 * bodyHeight,
                  // onError: (ex) {
                  //   print("[QR] ERROR - $ex");
                  //   setState((){
                  //     _inputErrorText = "Error! Maybe your input value is too long?";
                  //   });
                  // },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}