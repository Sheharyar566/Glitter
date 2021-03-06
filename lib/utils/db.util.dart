import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glitter/models/palette.dart';
import 'package:glitter/utils/functions.util.dart';
import 'package:hive_flutter/hive_flutter.dart';

class _DBService {
  final String _colorsDB = 'favoriteColors';
  final String _paletteDB = 'favoritePalettes';
  final String _settingsDB = 'settings';

  // Settings database String
  final String _darkMode = 'darkMode';
  final String _isReviewed = 'isReviewed';
  final String _runCount = 'runCount';
  final String _isLater = 'isLater';

  // Palletes Strings
  final String _customPalette = 'customPalette';

  Future<void> init() async {
    try {
      Hive.registerAdapter(PaletteAdapter());

      await Hive.initFlutter();

      await Hive.openBox<String>(_colorsDB);
      await Hive.openBox<Palette>(_paletteDB);
      final Box<dynamic> _settings = await Hive.openBox<dynamic>(_settingsDB);

      final int _count = _settings.get(this._runCount, defaultValue: 0);
      await _settings.put(this._runCount, _count + 1);

      print('Initialized hive databases');
    } catch (e) {
      print('Failed to initialize the hive databases: $e');
    }
  }

  List<Palette> getPalettes() {
    try {
      final Box<Palette> _box = Hive.box<Palette>(_paletteDB);
      final List<Palette> _palettes = _box.values.toList();

      return _palettes;
    } catch (e) {
      print('Error occured while getting the palettes from db: $e');

      return [];
    }
  }

  Future<void> addOrUpdatePalette(Palette _palette, String? _id) async {
    try {
      final isPaletteValid = verifyPalette(_palette);
      if (!isPaletteValid) {
        throw new Exception('Palette is invalid!');
      }

      print(Hive.isBoxOpen(this._paletteDB));
      final Box<Palette> _box = Hive.box<Palette>(this._paletteDB);
      await _box.put(_id != null ? _id : _palette.id, _palette);
    } catch (e) {
      print('Error occured while adding the palette to palettes db: $e');
      throw e;
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
      print('Error occured while updating the palette in db: $e');
      throw e;
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

  List<String> getCustomPalette() {
    try {
      final Box<Palette> _box = Hive.box<Palette>(this._paletteDB);
      final Palette? _temp = _box.get(this._customPalette);

      if (_temp == null) {
        return [];
      } else {
        return _temp.colors;
      }
    } catch (e) {
      print('Error occured while getting the custom palette: $e');
      throw e;
    }
  }

  Future<bool> addColorToCustomPalette(String _color) async {
    try {
      final Box<Palette> _box = Hive.box<Palette>(this._paletteDB);
      final Palette? _temp = _box.get(this._customPalette);

      if (_temp != null) {
        final List<String> _colorsList = _temp.colors;
        _colorsList.add(_color);

        await _box.put(this._customPalette, _temp);

        return true;
      } else {
        _box.put(
          this._customPalette,
          Palette(
            id: this._customPalette,
            name: 'Custom Palette',
            colors: [_color],
          ),
        );

        return true;
      }
    } catch (e) {
      print('Error occured while adding color to the custom palette: $e');
      return false;
    }
  }

  Future<void> clearCustomPalette() async {
    try {
      final Box<Palette> _box = Hive.box<Palette>(this._paletteDB);
      final Palette? _temp = _box.get(this._customPalette);

      if (_temp == null) {
        return;
      } else {
        _temp.colors = [];
        _box.put(this._customPalette, _temp);
      }
    } catch (e) {
      print('Error occured while clearing the custom palette : $e');
      throw e;
    }
  }

  Future<void> addColor(String _color) async {
    try {
      final Box<String> _box = Hive.box<String>(_colorsDB);
      await _box.add(_color.toUpperCase());
    } catch (e) {
      print('Error occured while adding the color to colors db: $e');
      throw e;
    }
  }

  Future<void> deleteColorWithIndex(int _index) async {
    try {
      final Box<String> _box = Hive.box<String>(_colorsDB);
      await _box.deleteAt(_index);
    } catch (e) {
      print('Error occured while deleting the colors with index: $e');
      throw e;
    }
  }

  Future<void> deleteColor(String _color) async {
    try {
      final Box<String> _box = Hive.box<String>(_colorsDB);
      final int _temp = _box.values.toList().indexOf(_color);

      await _box.deleteAt(_temp);
    } catch (e) {
      print('Error occured while delete the colors: $e');
      throw e;
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
      print('Error occured while getting the colors list: $e');
      return [];
    }
  }

  // Settings setters and getters
  ValueListenable<Box<dynamic>> get darkModeListenable =>
      Hive.box<dynamic>(_settingsDB).listenable(keys: [_darkMode]);

  bool get darkMode =>
      Hive.box(_settingsDB).get(_darkMode, defaultValue: false);

  set darkMode(bool _value) {
    Hive.box(_settingsDB).put(_darkMode, _value);
  }

  // Review setters and getters
  int get runCount {
    try {
      final Box<dynamic> _box = Hive.box<dynamic>(this._settingsDB);
      final int _runCount = _box.get(this._runCount);

      return _runCount;
    } catch (e) {
      throw e;
    }
  }

  bool get isReviewed {
    try {
      final Box<dynamic> _box = Hive.box<dynamic>(this._settingsDB);
      final bool _isReviewed = _box.get(this._isReviewed, defaultValue: false);

      return _isReviewed;
    } catch (e) {
      throw e;
    }
  }

  bool get isLater {
    try {
      final Box<dynamic> _box = Hive.box<dynamic>(this._settingsDB);
      final bool _isLater = _box.get(this._isLater, defaultValue: false);

      return _isLater;
    } catch (e) {
      throw e;
    }
  }

  Future<void> setIsReviewed(bool status) async {
    try {
      final Box<dynamic> _box = Hive.box<dynamic>(this._settingsDB);
      await _box.put(this._isReviewed, status);
    } catch (e) {
      throw e;
    }
  }

  Future<void> setIsLater(bool status) async {
    try {
      final Box<dynamic> _box = Hive.box<dynamic>(this._settingsDB);
      await _box.put(this._isLater, status);
      await _box.put(this._runCount, 0);
    } catch (e) {
      throw e;
    }
  }

  // Palettes getters and setters
  String get customPaletteID => this._customPalette;
}

final _DBService dbService = new _DBService();
