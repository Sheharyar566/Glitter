import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

// class ExportImageArgs {
//   final String name;
//   final RenderRepaintBoundary boundary;

//   const ExportImageArgs(this.name, this.boundary);
// }

Future<int> exportGradientToImage(Map data) async {
  try {
    final Directory? dir = await getExternalStorageDirectory();

    if (dir == null) {
      throw new Exception('Null directory');
    }

    final String path = '${dir.path}/exports/demo.png';

    final File file = File(path);

    final Uint8List bytes = data['bytes'].buffer.asUint8List();

    await file.writeAsBytes(bytes);
    print('Exported');
    return 0;
  } catch (e) {
    print(e);
    return 1;
  }
}
