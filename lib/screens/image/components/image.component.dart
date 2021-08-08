import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final Uint8List imageData;
  final isPickerEnabled;
  const ImageViewer(
      {Key? key, required this.imageData, required this.isPickerEnabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InteractiveViewer(
        onInteractionStart: (value) {
          print(value.focalPoint);
          print(value.localFocalPoint);
        },
        onInteractionUpdate: (value) {
          print(value.focalPoint);
          print(value.localFocalPoint);
        },
        scaleEnabled: !isPickerEnabled,
        panEnabled: !isPickerEnabled,
        child: Image.memory(
          imageData,
          width: double.maxFinite,
          height: double.maxFinite,
        ),
      ),
    );
  }
}
