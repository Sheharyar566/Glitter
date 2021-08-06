import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:glitter/models/palette.dart';
import 'package:glitter/utils/db.util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';

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

Future<List<Color>> generatePallete(Uint8List _image) async {
  final PaletteGenerator _generator =
      await PaletteGenerator.fromImageProvider(MemoryImage(_image));

  return _generator.colors.toList();
}

Future<void> addPalette(Palette _palette) async {
  await dbService.addPalette(_palette);
}

Future<Uint8List?> pickImage(int _) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? _image = await _picker.pickImage(source: ImageSource.gallery);

  if (_image == null) {
    return null;
  }

  final Uint8List _imageData = await _image.readAsBytes();
  return _imageData;
}
