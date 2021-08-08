import 'dart:ui';

import 'package:flutter/material.dart';

class Magnifier extends StatefulWidget {
  final Offset position;
  const Magnifier({Key? key, required this.position}) : super(key: key);

  @override
  _MagnifierState createState() => _MagnifierState();
}

class _MagnifierState extends State<Magnifier> {
  final double _size = 50;
  final double _scale = 10;
  late Matrix4 _matrix4;

  void _updateMatrix() {
    final double x = widget.position.dx - (_size / 2);
    final double y = widget.position.dy - (_size / 2);

    final Matrix4 _tempMatrix = Matrix4.identity()
      ..scale(_scale, _scale)
      ..translate(-x, -y);

    setState(() {
      _matrix4 = _tempMatrix;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.matrix(_matrix4.storage),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                width: 2,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MagnifierCircle extends CustomPainter {
  final Color _color = Color(0xFF777777);
  final double _strokeWidth = 4;
  final double _gridLines = 6;

  @override
  void paint(Canvas canvas, Size size) {
    _drawCircle(canvas, size);
    _drawGrid(canvas, size);
    _drawBox(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawCircle(Canvas canvas, Size size) {
    final Paint _paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..color = _color;

    canvas.drawCircle(
      size.center(Offset(0, 0)),
      size.longestSide / 2,
      _paint,
    );
  }

  void _drawGrid(Canvas canvas, Size size) {
    final Paint _paint = Paint()
      ..strokeWidth = _strokeWidth / 2
      ..color = _color;

    final double _gridItemHeight = (size.height / _gridLines) - _strokeWidth;
    final double _gridItemWidth = (size.width / _gridLines) - _strokeWidth;

    for (int i = 1; i <= _gridLines; i++) {
      canvas.drawLine(Offset(0, _gridItemHeight * i),
          Offset(size.width, _gridItemHeight * i), _paint);

      canvas.drawLine(Offset(_gridItemWidth * i, 0),
          Offset(_gridItemWidth * i, size.height), _paint);
    }
  }

  void _drawBox(Canvas canvas, Size size) {
    final Paint _paint = Paint()
      ..strokeWidth = _strokeWidth / 2
      ..color = Colors.red;

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(20, 40, 100, 100), Radius.zero),
      _paint,
    );
  }
}
