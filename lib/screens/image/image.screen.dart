import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:glitter/components/color.component.dart';
import 'package:glitter/models/palette.dart';
import 'package:glitter/utils/functions.util.dart';
import 'package:flutter/material.dart';
import 'package:glitter/components/appbar.component.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen>
    with SingleTickerProviderStateMixin {
  Uint8List? imageData;
  List<Color>? pallete;
  bool maximize = false;
  String? name;

  Future<void> _pickImage(BuildContext context) async {
    try {
      final Uint8List _imageData = await compute(pickImage, 0);
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

  void _generateColorPalette(BuildContext context) async {
    try {
      final List<Color> _temp = await compute(
        generatePallete,
        this.imageData as Uint8List,
      );

      setState(() {
        pallete = _temp;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pallete Generated!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      );
    } catch (e) {
      print('Error occured while generating the palette: $e');
    }
  }

  void _addToFavorites(BuildContext context) async {
    try {
      await compute(
        addPalette,
        Palette(
          name: this.name as String,
          colors: (this.pallete as List<Color>)
              .map((_color) => colorToHex(_color))
              .toList(),
        ),
      );

      Navigator.of(context, rootNavigator: true).pop();

      setState(() {
        name = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Palette added to favorites!'),
      ));
    } catch (e) {
      print('Failed to add the palette to your favorites list: $e');
    }
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter a name for your palette',
                style: Theme.of(context)
                    .primaryTextTheme
                    .bodyText2
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextFormField(
                initialValue: name,
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                style: Theme.of(context).primaryTextTheme.bodyText2,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text('Add to Favorites'),
              onPressed: () async {
                _addToFavorites(context);
              },
            ),
          ],
        );
      },
    );
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
          : Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    onInteractionStart: (value) {
                      print(value);
                    },
                    child: Image.memory(
                      imageData as Uint8List,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (pallete != null)
                                  IconButton(
                                    onPressed: () {
                                      showAlertDialog(context);
                                    },
                                    tooltip: 'Add to favorite palettes',
                                    icon: Icon(Icons.favorite),
                                  ),
                                pallete != null
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            maximize = !maximize;
                                          });
                                        },
                                        tooltip:
                                            maximize ? 'Minimize' : 'Maximize',
                                        icon: Icon(
                                          maximize
                                              ? Icons.minimize
                                              : Icons.palette,
                                        ),
                                      )
                                    : IconButton(
                                        tooltip: 'Generate pallete',
                                        onPressed: () {
                                          _generateColorPalette(context);
                                        },
                                        icon: Icon(Icons.done),
                                      ),
                                IconButton(
                                  tooltip: 'Reset',
                                  onPressed: () {
                                    setState(() {
                                      imageData = null;
                                    });
                                  },
                                  icon: Icon(Icons.close),
                                ),
                              ],
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              height: maximize
                                  ? MediaQuery.of(context).size.height * 0.7
                                  : 0,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: pallete != null
                                      ? Column(
                                          children: (pallete as List<Color>)
                                              .asMap()
                                              .entries
                                              .map(
                                                (e) => ColorComponent(
                                                  color: e.value,
                                                  remove: () {},
                                                ),
                                              )
                                              .toList(),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
