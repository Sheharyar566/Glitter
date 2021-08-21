import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:glitter/models/palette.dart';
import 'package:glitter/utils/db.util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

String colorToHex(Color _color) {
  final int _red = _color.red;
  final int _green = _color.green;
  final int _blue = _color.blue;

  final String _redString = _red.toRadixString(16);
  final String _blueString = _blue.toRadixString(16);
  final String _greenString = _green.toRadixString(16);

  print('ColorToHex: $_color');

  final String _tempColor =
      '#${_redString.length == 1 ? '0$_redString' : _redString}${_greenString.length == 1 ? '0$_greenString' : _greenString}${_blueString.length == 1 ? '0$_blueString' : _blueString}';

  return _tempColor.toUpperCase();
}

Color hexToColor(String _color) {
  String _hexColor = _color.replaceAll('#', '');

  print('HexToColor: $_hexColor');

  if (_hexColor == '0') {
    return Colors.white;
  }

  if (_hexColor.length <= 2) {
    _hexColor =
        '0xFF' + _hexColor + List.filled(6 - _hexColor.length, 'F').join();
  } else if (_hexColor.length == 3) {
    _hexColor = '0xFF' +
        _hexColor.split('').map((color) => color + color).toList().join();
  } else if (_hexColor.length <= 5) {
    _hexColor = '0xFF' +
        _hexColor.substring(0, 2) +
        _hexColor
            .substring(2)
            .split('')
            .map((color) => color + color)
            .toList()
            .join();
  } else if (_hexColor.length == 6) {
    _hexColor = '0xFF' + _hexColor;
  } else if (_hexColor.length == 8) {
    _hexColor = '0x' + _hexColor;
  }

  final Color _tempColor = Color(int.parse(_hexColor));

  return _tempColor;
}

bool verifyPalette(Palette _palette) {
  if (_palette.name.isEmpty || _palette.colors.length == 0) {
    return false;
  }

  return true;
}

Future<void> addPalette(Palette _palette) async {
  try {
    await dbService.addOrUpdatePalette(_palette, null);
  } catch (e) {
    throw e;
  }
}

Future<Uint8List> loadImageData(XFile _image) async {
  try {
    final Uint8List _data = await _image.readAsBytes();
    return _data;
  } catch (e) {
    print('Failed to convert image to bytes: $e');
    throw e;
  }
}

Future<img.Image?> decodeImageData(Uint8List _image) async {
  try {
    final img.Image? _tempImage = img.decodeImage(_image.buffer.asUint8List());

    return _tempImage;
  } catch (e) {
    print('Failed to convert image to bytes: $e');
    throw e;
  }
}

int abgrToArgb(int argbColor) {
  int r = (argbColor >> 16) & 0xFF;
  int b = argbColor & 0xFF;
  return (argbColor & 0xFF00FF00) | (b << 16) | r;
}
