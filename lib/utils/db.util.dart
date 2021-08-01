import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class _DBService {
  final String _colorsDB = 'favoriteColors';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_colorsDB);
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

  Future<List<Color>> getColors() async {
    try {
      final Box<String> _box = Hive.box<String>(_colorsDB);
      final List<String> _hexValues = _box.values.toList();

      final List<Color> _colors = _hexValues.map<Color>((_color) {
        final _value = 'FF${_color.substring(1)}';
        return Color(int.parse(_value, radix: 16));
      }).toList();

      return _colors;
    } catch (e) {
      return [];
    }
  }
}

final _DBService dbService = new _DBService();
