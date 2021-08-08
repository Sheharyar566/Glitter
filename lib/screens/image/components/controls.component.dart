import 'dart:typed_data';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:glitter/components/color.component.dart';
import 'package:glitter/screens/image/components/button.component.dart';
import 'package:glitter/screens/image/components/favorite.component.dart';
import 'package:glitter/utils/themes.util.dart';
import 'package:palette_generator/palette_generator.dart';

class Controls extends StatefulWidget {
  final Uint8List imageData;
  final Function onReset;
  final Function togglePicker;
  const Controls({
    Key? key,
    required this.imageData,
    required this.onReset,
    required this.togglePicker,
  }) : super(key: key);

  @override
  _ControlsState createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  List<Color>? _palette;
  bool _isLoading = false;
  bool _isMaximized = false;
  bool _showAlert = false;

  void _generateColorPalette(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final PaletteGenerator _temp = await PaletteGenerator.fromImageProvider(
          MemoryImage(widget.imageData));

      setState(() {
        _isLoading = false;
        _palette = _temp.colors.toList();
      });

      Flushbar(
        message: 'Pallete Generated!',
        duration: const Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Themes.primaryColor,
        messageColor: Themes.textColor,
      )..show(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error occured while generating the palette: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
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
                if (_showAlert)
                  FavoriteAlert(
                    palette: _palette,
                    onDone: () {
                      setState(() {
                        _showAlert = false;
                      });
                    },
                  ),
                !_isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomButton(
                            onPressed: () {
                              widget.togglePicker();
                            },
                            icon: Icons.colorize_outlined,
                            toolTip: 'Enable color picker',
                          ),
                          if (_palette != null)
                            CustomButton(
                              onPressed: () {
                                setState(() {
                                  _showAlert = true;
                                });
                              },
                              toolTip: 'Add to favorite palettes',
                              icon: Icons.favorite,
                            ),
                          _palette != null
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isMaximized = !_isMaximized;
                                    });
                                  },
                                  tooltip:
                                      _isMaximized ? 'Minimize' : 'Maximize',
                                  icon: Icon(
                                    _isMaximized
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
                                _isMaximized = false;
                                _palette = null;
                              });

                              widget.onReset();
                            },
                            icon: Icon(Icons.close),
                          ),
                        ],
                      )
                    : Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: 22.5,
                            height: 22.5,
                            child: CircularProgressIndicator(
                              color: Themes.primaryColor,
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      ),
                if (_isMaximized)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: _palette != null
                            ? Column(
                                children: (_palette as List<Color>)
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
    );
  }
}
