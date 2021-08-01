import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class CustomPicker extends StatefulWidget {
  final Function onSelected;
  CustomPicker({required this.onSelected});

  @override
  _CustomPickerState createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  Color _selectedColor = Colors.red;

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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              ColorPicker(
                enableOpacity: false,
                enableTooltips: true,
                pickersEnabled: {
                  ColorPickerType.wheel: true,
                },
                title: Text(
                  'Select a color',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                onColorChanged: (_color) {
                  setState(() {
                    this._selectedColor = _color;
                  });
                },
                color: _selectedColor,
              ),
              SizedBox(
                height: 7.5,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextButton(
                    child: Icon(Icons.done),
                    onPressed: () {
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
