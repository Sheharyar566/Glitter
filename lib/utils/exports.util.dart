import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class ExportImageArgs {
  final String name;
  final RenderRepaintBoundary boundary;

  const ExportImageArgs(this.name, this.boundary);
}

Future<void> exportGradientToImage(RenderRepaintBoundary boundary) async {
  try {
    final Directory? dir = await getExternalStorageDirectory();

    if (dir == null) {
      throw new Exception('Null directory');
    }

    final String path = '${dir.path}/exports/demo.png';

    final File file = File(path);

    final ui.Image image = await boundary.toImage(pixelRatio: 10);
    final ByteData? bytesData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    if (bytesData == null) {
      throw new Exception('Failed to convert image to bytes');
    }

    final Uint8List bytes = bytesData.buffer.asUint8List();

    await file.writeAsBytes(bytes);
  } catch (e) {
    throw e;
  }
}
