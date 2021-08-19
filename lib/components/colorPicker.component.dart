import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:glitter/utils/functions.util.dart';

class CustomPicker extends StatefulWidget {
  final Function onSelected;
  CustomPicker({required this.onSelected});

  @override
  _CustomPickerState createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  late final TextEditingController _controller;
  Color _selectedColor = Colors.red;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.value = TextEditingValue(text: colorToHex(_selectedColor));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 15,
            right: 15,
            bottom: 10,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Pick a color'),
              ),
              ColorPicker(
                enableOpacity: false,
                enableTooltips: true,
                pickersEnabled: {
                  ColorPickerType.wheel: true,
                },
                onColorChanged: (_color) {
                  setState(() {
                    this._selectedColor = _color;
                  });
                  _controller.value = TextEditingValue(
                    text: colorToHex(_color),
                  );
                },
                color: _selectedColor,
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Or paste/edit here'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  maxLength: 7,
                  controller: _controller,
                  decoration: InputDecoration(
                    counterText: '',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedColor = hexToColor(value);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextButton(
                    child: Icon(Icons.done),
                    onPressed: () {
                      final _color = _controller.text;
                      final RegExp _hex = RegExp(r'^#?([0-9a-fA-F]{6})');
                      if (_color.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Color should not be empty!'),
                          ),
                        );

                        return;
                      } else if (!_hex.hasMatch(_color)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid color'),
                          ),
                        );

                        return;
                      }

                      widget.onSelected(_selectedColor);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
