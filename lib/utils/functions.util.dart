import 'package:flutter/material.dart';

String colorToHex(Color _color) {
  return '#${_color.value.toRadixString(16).substring(2).toUpperCase()}';
}

Color hexToColor(String _color) {
  return Color(int.parse('FF${_color.substring(1)}', radix: 16));
}
