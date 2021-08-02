import 'dart:typed_data';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter/material.dart';
import 'package:glitter/components/appbar.component.dart';
import 'package:image_picker/image_picker.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  Uint8List? imageData;

  Future<void> _pickImage(BuildContext context) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? _image =
          await _picker.pickImage(source: ImageSource.gallery);

      if (_image == null) {
        throw new Exception('Got null instead of an image');
      }

      final Uint8List _imageData = await _image.readAsBytes();
      setState(() {
        imageData = _imageData;
      });
    } catch (e) {
      print('Failed to pick image from the gallery: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> _generatePallete() async {
    try {
      final PaletteGenerator _generator =
          await PaletteGenerator.fromImageProvider(
        MemoryImage(imageData as Uint8List),
      );

      print(_generator.colors);
      print(_generator.paletteColors);
    } catch (e) {
      print('Failed to generate color pallete: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        'Image Palette',
      ),
      body: imageData == null
          ? Center(
              child: Ink.image(
                image: AssetImage(
                  'assets/icons/image.png',
                ),
                width: 100,
                height: 100,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.0),
                  onTap: () {
                    _pickImage(context);
                  },
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Flex(
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _generatePallete,
                        icon: Icon(Icons.done),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            imageData = null;
                          });
                        },
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Image.memory(
                    imageData as Uint8List,
                  ),
                ),
              ],
            ),
    );
  }
}
