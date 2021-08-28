import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:glitter_pro/utils/functions.util.dart';

class GradientComponent extends StatelessWidget {
  final StreamController<List<Color>> controller;
  final String name;
  final List<List<int>> colors;
  GradientComponent({
    Key? key,
    required this.controller,
    required this.name,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> colorsList =
        this.colors.map((e) => rgbToColor(e)).toList();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      margin: const EdgeInsets.all(0),
      child: GestureDetector(
        onTap: () {
          controller.add(colorsList);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: colorsList,
            ),
          ),
        ),
      ),
    );
  }
}
