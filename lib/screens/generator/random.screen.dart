import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:glitter/components/appbar.component.dart';
import 'package:glitter/components/color.component.dart';
import 'package:glitter/components/drawer.component.dart';
import 'package:glitter/components/favorite.component.dart';
import 'package:glitter/models/palette.dart';
import 'package:glitter/utils/db.util.dart';
import 'package:glitter/utils/functions.util.dart';
import 'package:palette/palette.dart';
import 'package:uuid/uuid.dart';

class RandomScreen extends StatefulWidget {
  @override
  _RandomScreenState createState() => _RandomScreenState();
}

class _RandomScreenState extends State<RandomScreen> {
  late List<Color> _colors;
  int _count = 6;
  bool _showDialog = false;
  bool _isFavorite = false;

  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    this.generatePalette();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void generatePalette() {
    final ColorPalette _palette = ColorPalette.random(_count, unique: true);
    final List<Color> _temp = _palette.map((color) {
      int red = color.toRgbColor().red;
      int green = color.toRgbColor().green;
      int blue = color.toRgbColor().blue;

      return Color.fromRGBO(red, green, blue, 1);
    }).toList();

    setState(() {
      if (_isFavorite) {
        _isFavorite = false;
      }

      _colors = _temp;
    });
  }

  void addColor() {
    final ColorPalette _temp = ColorPalette.random(1);
    final RgbColor _rgbColor = _temp.colors[0].toRgbColor();
    final Color _color =
        Color.fromRGBO(_rgbColor.red, _rgbColor.green, _rgbColor.blue, 1);

    final bool _isAlreadyPresent =
        _colors.where((element) => element.value == _color.value).length > 0;

    if (!_isAlreadyPresent) {
      setState(() {
        _colors.add(_color);

        _count = _count + 1;
      });

      SchedulerBinding.instance?.addPostFrameCallback((_) {
        _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    } else {
      addColor();
    }
  }

  Future<void> _onFavorited(BuildContext context, String _name) async {
    setState(() {
      _showDialog = false;
    });

    if (!_isFavorite) {
      try {
        await dbService.addOrUpdatePalette(
          Palette(
            id: Uuid().v4(),
            name: _name,
            colors: _colors.map((e) => colorToHex(e)).toList(),
          ),
          null,
        );

        setState(() {
          _isFavorite = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Palette added to favorites!'),
        ));
      } catch (e) {
        print('Error occured while adding a random palette to db: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Palette already in favorites'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        titleText: 'Random Palette',
        actionsList: [
          IconButton(
            onPressed: generatePalette,
            icon: Icon(
              Icons.restart_alt_outlined,
            ),
          ),
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
                  Container(
                    constraints: BoxConstraints(maxHeight: 115),
                    child: OutlinedButton(
                      onPressed: addColor,
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
              onCancelled: () {
                setState(() {
                  _showDialog = false;
                });
              },
              onFavorited: (String _name) {
                _onFavorited(context, _name);
              },
            ),
        ],
      ),
    );
  }
}
