import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:glitter/components/appbar.component.dart';
import 'package:glitter/components/color.component.dart';
import 'package:glitter/components/colorPicker.component.dart';
import 'package:glitter/components/drawer.component.dart';
import 'package:glitter/components/favorite.component.dart';
import 'package:glitter/utils/db.util.dart';
import 'package:glitter/utils/functions.util.dart';
import 'package:palette/palette.dart';

class PaletteEditor extends StatefulWidget {
  final List<Color>? colorsList;
  const PaletteEditor({Key? key, this.colorsList}) : super(key: key);

  @override
  _PaletteEditorState createState() => _PaletteEditorState();
}

class _PaletteEditorState extends State<PaletteEditor> {
  late final ScrollController _controller;
  late List<Color> _colors;
  late int _count;
  bool _isPickerIntended = false;
  bool _showDialog = false;
  bool _isFavorite = false;

  @override
  void initState() {
    _controller = ScrollController();

    if (widget.colorsList != null) {
      _colors = widget.colorsList!;
      _count = widget.colorsList!.length;
    } else {
      _colors = [];
      _count = 0;
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void addColor() {
    ColorPalette _temp = ColorPalette.random(1);
    RgbColor _color = _temp.colors[0].toRgbColor();

    setState(() {
      _colors.add(
        Color.fromRGBO(_color.red, _color.green, _color.blue, 1),
      );

      _count = _count + 1;
    });

    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        titleText: 'Palette Editor',
        actionsList: [
          IconButton(
            onPressed: () {
              setState(() {
                _showDialog = true;
              });
            },
            icon: Icon(
              Icons.favorite,
              color: _isFavorite ? Colors.red : null,
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _controller,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ..._colors.map(
                    (color) => ColorComponent(
                      key: ValueKey(color),
                      color: color,
                      remove: () async {
                        try {
                          await dbService.deleteColor(colorToHex(color));
                        } catch (e) {
                          print('Error occured');
                        }
                        setState(() {
                          _colors
                              .removeWhere((item) => item.value == color.value);
                          _count = _count - 1;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_isPickerIntended)
                    CustomPicker(
                      onSelected: (_color) async {
                        try {
                          await dbService.addColor(colorToHex(_color));
                          setState(() {
                            _colors.add(_color);
                            _isPickerIntended = false;
                          });
                        } catch (e) {
                          print('Error occured while selecting a color');
                        }
                      },
                    ),
                  if (_isPickerIntended)
                    SizedBox(
                      height: 10,
                    ),
                  Container(
                    constraints: BoxConstraints(maxHeight: 115),
                    child: OutlinedButton(
                      onPressed: () {
                        if (!_isPickerIntended) {
                          setState(() {
                            _isPickerIntended = true;
                          });
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(Icons.add),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Add New Color',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showDialog)
            FavoriteAlert(
              palette: this._colors,
              onDone: (bool wasFavorited) {
                setState(() {
                  _showDialog = false;

                  if (wasFavorited) {
                    _isFavorite = true;
                  }
                });
              },
            ),
        ],
      ),
    );
  }
}
