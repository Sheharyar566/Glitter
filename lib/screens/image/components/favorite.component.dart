import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glitter/models/palette.dart';
import 'package:glitter/utils/functions.util.dart';

class FavoriteAlert extends StatefulWidget {
  final List<Color>? palette;
  final Function onDone;
  const FavoriteAlert({Key? key, required this.palette, required this.onDone})
      : super(key: key);

  @override
  _FavoriteAlertState createState() => _FavoriteAlertState();
}

class _FavoriteAlertState extends State<FavoriteAlert> {
  String name = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter a name for your palette',
                    style: Theme.of(context)
                        .primaryTextTheme
                        .bodyText2
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
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
                    widget.onDone();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Add to Favorites'),
                  onPressed: () async {
                    this._addToFavorites(context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    });
  }

  void _addToFavorites(BuildContext context) async {
    try {
      if (widget.palette == null) {
        return;
      }

      await compute(
        addPalette,
        Palette(
          name: this.name,
          colors: (widget.palette as List<Color>)
              .map((_color) => colorToHex(_color))
              .toList(),
        ),
      );

      setState(() {
        name = '';
      });

      widget.onDone();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Palette added to favorites!'),
      ));
    } catch (e) {
      print('Failed to add the palette to your favorites list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
