import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:glitter/components/appbar.component.dart';
import 'package:glitter/components/color.component.dart';
import 'package:glitter/components/colorPicker.component.dart';
import 'package:glitter/components/drawer.component.dart';
import 'package:glitter/components/favorite.component.dart';
import 'package:glitter/models/palette.dart';
import 'package:glitter/utils/db.util.dart';
import 'package:glitter/utils/functions.util.dart';
import 'package:palette/palette.dart';
import 'package:uuid/uuid.dart';

class EditorParams {
  final bool? isCustom;
  final Palette? palette;

  EditorParams({this.isCustom, this.palette});
}

class PaletteEditor extends StatefulWidget {
  final bool? isCustom;
  final Palette? palette;
  const PaletteEditor({Key? key, this.isCustom, this.palette})
      : assert(isCustom != null || palette != null),
        super(key: key);

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
    initPalette();
    super.initState();
  }

  void initPalette() {
    if (widget.isCustom == true) {
      try {
        final List<String> _temp = dbService.getCustomPalette();
        final List<Color> _tempColors =
            _temp.map((_color) => hexToColor(_color)).toList();

        setState(() {
          _colors = _tempColors;
          _count = _tempColors.length;
        });

        return;
      } catch (e) {
        print('Error occured while getting the custom palette from db: $e');
      }
    } else if (widget.palette != null) {
      final Palette _palette = widget.palette!;
      setState(() {
        _colors = _palette.colors.map((_color) => hexToColor(_color)).toList();
        _count = _palette.colors.length;
      });

      return;
    }

    setState(() {
      _colors = [];
      _count = 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void addColor(BuildContext context, Color _color) async {
    try {
      final bool _isAlreadyPresent =
          _colors.where((element) => _color.value == element.value).length > 0;

      if (!_isAlreadyPresent) {
        setState(() {
          _colors.add(_color);
          _count = _count + 1;
          _isPickerIntended = false;
        });

        SchedulerBinding.instance?.addPostFrameCallback((_) {
          _controller.animateTo(
            _controller.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cannot add duplicate colors'),
          ),
        );
      }
    } catch (e) {
      print('Failed to add color to the palette: $e');
    }
  }

  Future<void> _onFavorited(BuildContext context, String _name) async {
    setState(() {
      _showDialog = false;
    });

    try {
      await compute(
        addPalette,
        Palette(
          id: widget.palette == null ? Uuid().v4() : widget.palette!.id,
          name: _name,
          colors: _colors.map((_color) => colorToHex(_color)).toList(),
        ),
      );

      await dbService.clearCustomPalette();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Palette added to favorites!'),
      ));
    } catch (e) {
      print('Failed to add the palette to your favorites list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        titleText: 'Palette Editor',
        actionsList: _colors.length > 0
            ? [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showDialog = true;
                    });
                  },
                  icon: widget.palette != null
                      ? Icon(
                          Icons.save_rounded,
                        )
                      : Icon(
                          Icons.favorite,
                          color: _isFavorite ? Colors.red : null,
                        ),
                ),
              ]
            : [],
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
                      onSelected: (_color) {
                        addColor(context, _color);
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
              name: widget.palette == null ? null : widget.palette!.name,
              onFavorited: (String _name) {
                _onFavorited(context, _name);
              },
            ),
        ],
      ),
    );
  }
}
