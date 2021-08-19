import 'package:flutter/material.dart';
import 'package:glitter/components/appbar.component.dart';
import 'package:glitter/components/drawer.component.dart';
import 'package:glitter/enums/screens.enum.dart';
import 'package:glitter/models/palette.dart';
import 'package:glitter/screens/editor/editor.screen.dart';
import 'package:glitter/screens/palettes/components/palette.component.dart';
import 'package:glitter/utils/db.util.dart';
import 'package:uuid/uuid.dart';

class PaletteScreen extends StatefulWidget {
  const PaletteScreen({Key? key}) : super(key: key);

  @override
  _PaletteScreenState createState() => _PaletteScreenState();
}

class _PaletteScreenState extends State<PaletteScreen> {
  final ScrollController _controller = ScrollController();
  late List<Palette> _palettes;

  @override
  void initState() {
    _getPalettes();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _getPalettes() {
    try {
      final List<Palette> _temp = dbService.getPalettes();
      setState(() {
        _palettes = _temp;
      });
    } catch (e) {
      print('Error occured while loading the colors list');
    }
  }

  void _deletePalette(String _id) async {
    try {
      await dbService.deletePalette(_id);
      setState(() {
        _palettes.removeWhere((_palette) => _palette.id == _id);
      });
    } catch (e) {
      print('Error occured while loading the colors list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        titleText: 'Favorite Palettes',
      ),
      drawer: CustomDrawer(context),
      body: SingleChildScrollView(
        controller: _controller,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              ..._palettes.map(
                (_palette) => _palette.id != dbService.customPaletteID
                    ? PaletteComponent(
                        palette: _palette,
                        onEdit: () {
                          Navigator.pushNamed(
                            context,
                            Screen.editor,
                            arguments: EditorParams(palette: _palette),
                          );
                        },
                        onDelete: () {
                          _deletePalette(_palette.id);
                        },
                      )
                    : Container(),
              ),
              Container(
                constraints: BoxConstraints(maxHeight: 115),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Screen.editor,
                      arguments: EditorParams(
                        palette: Palette(
                          id: Uuid().v4(),
                          name: 'Untitled',
                          colors: [],
                        ),
                      ),
                    );
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
                        'Add New Palette',
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
