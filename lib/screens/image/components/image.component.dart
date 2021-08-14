import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:glitter/utils/functions.util.dart';
import 'package:image/image.dart' as img;

class ImageViewer extends StatefulWidget {
  final Uint8List imageData;
  final bool isPickerEnabled;
  final StreamController<Offset?> positionStream;
  final StreamController<Color?> colorStream;

  ImageViewer(
      {Key? key,
      required this.imageData,
      required this.isPickerEnabled,
      required this.positionStream,
      required this.colorStream})
      : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  final GlobalKey _imageKey = GlobalKey();
  img.Image? _image;
  int? _scale;

  void loadImageData() {
    final img.Image? _temp =
        img.decodeImage(widget.imageData.buffer.asUint8List());

    _image = _temp;
  }

  void getScaleValue() {
    final Size? _size = _imageKey.currentContext?.size;

    if (_size == null) {
      return;
    }

    final double _temp = _image!.width / _size.width;

    print(_temp);
    print(_temp.toInt());
    _scale = _temp.toInt();
  }

  void showMagnifier(DragDownDetails value) {
    if (!widget.isPickerEnabled) {
      return;
    }

    final Offset _position = value.localPosition;
    update(_position);
  }

  void updateValues(DragUpdateDetails value) {
    if (!widget.isPickerEnabled) {
      return;
    }

    final Offset _position = value.localPosition;
    update(_position);
  }

  void hideMagnifier(DragEndDetails value) {
    if (!widget.isPickerEnabled) {
      return;
    }

    widget.positionStream.add(null);
  }

  void update(Offset _position) {
    widget.positionStream.add(_position);

    if (_image == null) {
      loadImageData();
    }

    if (_scale == null) {
      getScaleValue();
    }

    final int _pixel = _image!.getPixelSafe(
        _position.dx.toInt() * (_scale as int),
        _position.dy.toInt() * (_scale as int));
    final int _hex = abgrToArgb(_pixel);

    widget.colorStream.add(hexToColor(_hex.toRadixString(16)));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onPanDown: showMagnifier,
        onPanUpdate: updateValues,
        onPanEnd: hideMagnifier,
        child: Image.memory(
          widget.imageData,
          key: _imageKey,
        ),
      ),
    );
  }
}
