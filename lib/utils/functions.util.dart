import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:glitter/models/palette.dart';
import 'package:glitter/utils/db.util.dart';
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

Future<void> addPalette(Palette _palette) async {
  await dbService.addPalette(_palette);
}

Future<List<Color>?> generatePalette(Uint8List _image) async {
  try {
    final PaletteGenerator _generator =
        await PaletteGenerator.fromImageProvider(MemoryImage(_image));

    return _generator.colors.toList();
  } catch (e) {
    print('Error occured while generating palette in the isolate: $e');
  }
}
