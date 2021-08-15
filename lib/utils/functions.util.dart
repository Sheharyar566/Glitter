import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:glitter/models/palette.dart';
import 'package:glitter/utils/db.util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

String colorToHex(Color _color) {
  return '#${_color.value.toRadixString(16).substring(2).toUpperCase()}';
}

Color hexToColor(String _color) {
  return Color(int.parse('FF${_color.substring(1)}', radix: 16));
}

bool verifyPalette(Palette _palette) {
  if (_palette.name.isEmpty || _palette.colors.length == 0) {
    return false;
  }

  return true;
}

Future<void> addPalette(Palette _palette) async {
  await dbService.addPalette(_palette);
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
