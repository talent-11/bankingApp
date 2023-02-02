import 'package:flutter/material.dart';

enum ChooseItem { camera, gallery }

class FotocCameraPopup extends StatelessWidget {
  const FotocCameraPopup(
    {
      Key? key,
      required this.onPressedCamera,
      required this.onPressedGallery
    }
  ) : super(key: key);

  final Function onPressedCamera;
  final Function onPressedGallery;

  @override
  Widget build(BuildContext context) {

    return Center(
        child: PopupMenuButton<ChooseItem>(
          // Callback that sets the selected popup menu item.
          onSelected: (ChooseItem item) {
            if (item == ChooseItem.camera) {
              onPressedCamera();
            } else {
              onPressedGallery();
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<ChooseItem>>[
            const PopupMenuItem<ChooseItem>(
              value: ChooseItem.camera,
              child: Text('From Camera'),
            ),
            const PopupMenuItem<ChooseItem>(
              value: ChooseItem.gallery,
              child: Text('From Gallery'),
            ),
          ],
        ),
      );
  }
}
