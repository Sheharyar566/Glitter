import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:glitter/utils/exports.util.dart';
import 'package:glitter/utils/functions.util.dart';

class GradientComponent extends StatelessWidget {
  final String name;
  final List<List<int>> colors;
  GradientComponent({
    Key? key,
    required this.name,
    required this.colors,
  }) : super(key: key);

  final GlobalKey _globalKey = GlobalKey();

  void copyColor(BuildContext context, String hexValue) async {
    await Clipboard.setData(
      ClipboardData(text: hexValue),
    );

    final SnackBar _snackBar = SnackBar(
      content: Text('$hexValue copied successfully!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  Future<void> captureImage() async {
    try {
      final RenderRepaintBoundary? boundary = _globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        throw new Exception('Failed to create gradient image');
      }

      await compute(
        exportGradientToImage,
        boundary,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = Theme.of(context).primaryTextTheme.bodyText2;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      shadowColor: Color.fromRGBO(colors[0][0], colors[0][1], colors[0][2], 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Column(
          children: [
            Stack(
              children: [
                RepaintBoundary(
                  key: _globalKey,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: this
                            .colors
                            .map((color) =>
                                Color.fromRGBO(color[0], color[1], color[2], 1))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                Flex(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  direction: Axis.horizontal,
                  children: List<Widget>.from(
                    this.colors.map(
                      (color) {
                        final String hexColor = rgbToHex(color);
                        return Expanded(
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                copyColor(context, hexColor);
                              },
                              child: Text(
                                rgbToHex(color),
                                style: style?.copyWith(
                                  color: hexColor.contains('FFFFFF')
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: style,
                  ),
                  Wrap(
                    runAlignment: WrapAlignment.end,
                    children: [
                      IconButton(
                        onPressed: captureImage,
                        icon: Icon(Icons.copy),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
