import 'package:flutter/material.dart';
import 'package:glitter/models/palette.dart';
import 'package:glitter/utils/functions.util.dart';
import 'package:hive_flutter/hive_flutter.dart';

class _DBService {
  final String _colorsDB = 'favoriteColors';
  final String _paletteDB = 'favoritePalettes';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_colorsDB);

    Hive.registerAdapter(PaletteAdapter());
    await Hive.openBox<Palette>(_paletteDB);
  }

  List<Palette> getPalettes() {
    try {
      final Box<Palette> _box = Hive.box<Palette>(_paletteDB);
      final List<Palette> _palettes = _box.values.toList();

      return _palettes;
    } catch (e) {
      print('Error occured while loading the colors db: $e');

      return [];
    }
  }

  Future<void> addPalette(Palette _palette) async {
    try {
      final isPaletteValid = verifyPalette(_palette);
      if (!isPaletteValid) {
        throw new Exception('Palette is invalid!');
      }

      final Box<Palette> _box = Hive.box<Palette>(_paletteDB);
      await _box.put(_palette.id, _palette);
    } catch (e) {
      print('Error occured while loading the colors db: $e');
    }
  }

  Future<void> editPalette(Palette _palette) async {
    try {
      final _isPaletteValid = verifyPalette(_palette);
      if (!_isPaletteValid) {
        throw new Exception('Palette is invalid!');
      }

      final Box<Palette> _box = Hive.box<Palette>(_paletteDB);
      await _box.put(_palette.id, _palette);
    } catch (e) {
      print('Error occured while loading the colors db: $e');
    }
  }

  Future<void> deletePalette(String _id) async {
    try {
      final Box<Palette> _box = Hive.box<Palette>(_paletteDB);
      await _box.delete(_id);
    } catch (e) {
      print('Error occured while deleting the colors with index: $e');
    }
  }

  Future<void> addColor(String _color) async {
    try {
      final Box<String> _box = Hive.box<String>(_colorsDB);
      await _box.add(_color.toUpperCase());
    } catch (e) {
      print('Error occured while loading the colors db: $e');
    }
  }

  Future<void> deleteColorWithIndex(int _index) async {
    try {
      final Box<String> _box = Hive.box<String>(_colorsDB);
      await _box.deleteAt(_index);
    } catch (e) {
      print('Error occured while deleting the colors with index: $e');
    }
  }

  Future<void> deleteColor(String _color) async {
    try {
      final Box<String> _box = Hive.box<String>(_colorsDB);
      final int _temp = _box.values.toList().indexOf(_color);

      await _box.deleteAt(_temp);
    } catch (e) {
      print('Error occured while delete the colors: $e');
    }
  }

  List<Color> getColors() {
    try {
      final Box<String> _box = Hive.box<String>(_colorsDB);
      final List<String> _hexValues = _box.values.toList();

      final List<Color> _colors = _hexValues.map<Color>((_color) {
        return hexToColor(_color);
      }).toList();

      return _colors;
    } catch (e) {
      return [];
    }
  }
}

final _DBService dbService = new _DBService();
