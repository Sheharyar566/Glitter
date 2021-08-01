import 'package:flutter/material.dart';
import 'package:glitter/components/appbar.component.dart';
import 'package:glitter/components/drawer.component.dart';
import 'package:glitter/utils/db.util.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late List<Color> colors;
  late int count;
  final ScrollController _controller = ScrollController();

  Future<void> getColors() async {
    try {
      final List<Color> _temp = await dbService.getColors();
      setState(() {
        colors = _temp;
        count = _temp.length;
      });
    } catch (e) {
      print('Error occured while loading the colors list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, 'Favorite Colors'),
      drawer: CustomDrawer(context),
      body: SingleChildScrollView(
        controller: _controller,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                constraints: BoxConstraints(maxHeight: 115),
                child: OutlinedButton(
                  onPressed: () {},
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
    );
  }
}
