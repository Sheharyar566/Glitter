import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class Magnifier extends StatelessWidget {
  final StreamController<Offset?> positionStream;
  const Magnifier({Key? key, required this.positionStream}) : super(key: key);

  final double _size = 135;
  final double _scale = 1;

  Matrix4 _updateMatrix(Offset position) {
    final double x = position.dx - (_size / (2 / _scale)) - (_size / 10);
    final double y = (position.dy) + (_size / (2 / _scale)) + (_size / 10);

    final Matrix4 _tempMatrix = Matrix4.identity()
      ..scale(_scale, _scale)
      ..translate(-x, -y);

    return _tempMatrix;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Offset?>(
      stream: positionStream.stream,
      builder: (context, snapshot) {
        final Offset? _position = snapshot.data;

        if (_position == null) {
          return Container();
        }

        return Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.matrix(_updateMatrix(_position).storage),
                child: CustomPaint(
                  painter: MagnifierCircle(),
                  size: Size(_size, _size),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MagnifierCircle extends CustomPainter {
  final Color _color = Color(0xFF888888);
  final double _strokeWidth = 2;
  final int _gridLines = 6;
  final double _dotSize = 2;

  @override
  void paint(Canvas canvas, Size size) {
    final double _gridItemSize =
        (size.height - (_gridLines * _strokeWidth)) / (_gridLines + 1);

    _drawCircle(canvas, size);
    _drawGrid(canvas, size, _gridItemSize);
    _drawBox(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
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

  void _drawGrid(Canvas canvas, Size size, double _gridItemSize) {
    final Paint _paint = Paint()
      ..strokeWidth = _strokeWidth / 2
      ..color = _color;

    for (int i = 1; i <= _gridLines; i++) {
      final double _spacing = (_gridItemSize * i) +
          (_strokeWidth / 2) +
          (i >= 2 ? (i - 1) * _strokeWidth : 0);

      canvas.drawLine(
          Offset(0, _spacing), Offset(size.width, _spacing), _paint);

      canvas.drawLine(
          Offset(_spacing, 0), Offset(_spacing, size.height), _paint);
    }
  }

  void _drawBox(Canvas canvas, Size size) {
    final Paint _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = _strokeWidth / 2
      ..color = Colors.white;

    canvas.drawCircle(size.center(Offset(0, 0)), _dotSize, _paint);
  }
}
