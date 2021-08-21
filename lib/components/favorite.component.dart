import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FavoriteAlert extends StatefulWidget {
  final void Function(String name) onFavorited;
  final void Function() onCancelled;
  final String? name;
  const FavoriteAlert(
      {Key? key,
      required this.onCancelled,
      required this.onFavorited,
      this.name})
      : super(key: key);

  @override
  _FavoriteAlertState createState() => _FavoriteAlertState();
}

class _FavoriteAlertState extends State<FavoriteAlert> {
  late String name;

  @override
  void initState() {
    super.initState();

    name = widget.name != null ? widget.name! : '';

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Enter a name for your palette'),
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
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onCancelled();
                },
              ),
              TextButton(
                child: Text('Add to Favorites'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  widget.onFavorited(name);
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
