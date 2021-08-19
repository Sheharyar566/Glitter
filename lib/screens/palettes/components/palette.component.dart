import 'package:flutter/material.dart';
import 'package:glitter/models/palette.dart';
import 'package:glitter/utils/functions.util.dart';

class PaletteComponent extends StatelessWidget {
  final Palette palette;
  final void Function() onEdit;
  final void Function() onDelete;
  const PaletteComponent({
    Key? key,
    required this.palette,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12.5,
        left: 0,
        right: 0,
        top: 0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              direction: Axis.horizontal,
              verticalDirection: VerticalDirection.down,
              children: palette.colors
                  .map(
                    (_color) => Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 2.5),
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: hexToColor(_color),
                      ),
                    ),
                  )
                  .toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(palette.name),
                Row(
                  children: [
                    IconButton(
                      onPressed: this.onEdit,
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: this.onDelete,
                      icon: Icon(Icons.delete),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
