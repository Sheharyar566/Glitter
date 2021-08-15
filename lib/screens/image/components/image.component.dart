import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:glitter/utils/functions.util.dart';
import 'package:image/image.dart' as img;

class ImageViewer extends StatefulWidget {
  final Uint8List imageData;
  final bool isPickerEnabled;
  final Function onLoadComplete;
  final StreamController<Offset?> positionStream;
  final StreamController<Color?> colorStream;

  ImageViewer(
      {Key? key,
      required this.imageData,
      required this.isPickerEnabled,
      required this.onLoadComplete,
      required this.positionStream,
      required this.colorStream})
      : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  final GlobalKey _imageKey = GlobalKey();
  late img.Image _image;
  late double _hScale;
  late double _vScale;

  @override
  void initState() {
    loadImageData();
    super.initState();
  }

  void loadImageData() async {
    final img.Image? _tempImage =
        await compute(decodeImageData, widget.imageData);

    if (_tempImage == null) {
      return;
    }

    _image = _tempImage;

    final Size? _size = _imageKey.currentContext?.size;

    if (_size == null) {
      return;
    }

    _hScale = _image.width / _size.width;
    _vScale = _image.height / _size.height;

    widget.onLoadComplete();
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

    final Offset _temp = Offset(_position.dx * _hScale, _position.dy * _vScale);

    final int _pixel = _image.getPixelSafe(_temp.dx.round(), _temp.dy.round());
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
