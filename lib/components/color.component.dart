import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glitter/utils/db.util.dart';
import 'package:glitter/utils/functions.util.dart';
import 'package:glitter/utils/themes.util.dart';

enum ColorSection { Details, Controls }

class ColorComponent extends StatefulWidget {
  final Color color;
  final bool? isFavoriteScreen;
  final void Function() remove;

  const ColorComponent({
    Key? key,
    required this.color,
    required this.remove,
    this.isFavoriteScreen,
  }) : super(key: key);

  @override
  _ColorComponentState createState() => _ColorComponentState();
}

class _ColorComponentState extends State<ColorComponent> {
  late bool isFavorite;
  bool isInPalette = false;
  ColorSection _section = ColorSection.Details;

  @override
  void initState() {
    isFavorite = widget.isFavoriteScreen != null
        ? widget.isFavoriteScreen as bool
        : false;
    super.initState();
  }

  void copyColor(BuildContext context, String hexValue) async {
    await Clipboard.setData(
      ClipboardData(text: hexValue),
    );

    final SnackBar _snackBar = SnackBar(
      content: Text('$hexValue copied successfully!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final String hexValue = colorToHex(widget.color);

    return Container(
      constraints: BoxConstraints(
        minHeight: 50,
        maxHeight: 125,
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(0),
      child: Card(
        margin: const EdgeInsets.all(0),
        elevation: 5,
        clipBehavior: Clip.hardEdge,
        shadowColor: this.widget.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: IndexedStack(
          index: _section.index,
          children: [
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                verticalDirection: VerticalDirection.down,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: this.widget.color,
                        borderRadius: BorderRadius.circular(17.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Flex(
                      clipBehavior: Clip.hardEdge,
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            child: Text(
                              hexValue,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline6
                                  ?.copyWith(
                                    letterSpacing: 1.5,
                                  ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _section = ColorSection.Controls;
                                });
                              },
                              tooltip: 'Show more options',
                              icon: Icon(Icons.more_vert_outlined),
                            ),
                            IconButton(
                              onPressed: () async {
                                try {
                                  if (isFavorite) {
                                    if (widget.isFavoriteScreen != null) {
                                      widget.remove();
                                    } else {
                                      await dbService.deleteColor(hexValue);
                                      setState(() {
                                        isFavorite = false;
                                      });
                                    }
                                  } else {
                                    await dbService.addColor(hexValue);
                                    setState(() {
                                      isFavorite = true;
                                    });
                                  }
                                } catch (e) {
                                  print(
                                      'Error occured while changing the favorite status: $e');
                                }
                              },
                              tooltip: isFavorite
                                  ? 'Remove favorite'
                                  : 'Add to favorites',
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_outline_rounded,
                                color: isFavorite
                                    ? Colors.red
                                    : Themes.primaryColor,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: Themes.boxBackground.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    Expanded(
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 15.0,
                        children: [
                          if (!isInPalette)
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () async {
                                try {
                                  final bool _wasAdded = await dbService
                                      .addColorToCustomPalette(hexValue);
                                  print(_wasAdded);

                                  if (_wasAdded) {
                                    setState(() {
                                      isInPalette = true;
                                    });
                                  }
                                } catch (e) {
                                  print(
                                      'Error occured while adding the color to custom palette: $e');
                                }
                              },
                            ),
                          IconButton(
                            icon: Icon(Icons.copy),
                            onPressed: () {
                              copyColor(context, hexValue);
                            },
                          ),
                          if (widget.isFavoriteScreen != true)
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: widget.remove,
                            ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _section = ColorSection.Details;
                          });
                        },
                        tooltip: 'Go back',
                        icon: Icon(Icons.close_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
