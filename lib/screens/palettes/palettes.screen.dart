import 'package:flutter/material.dart';
import 'package:glitter/components/drawer.component.dart';

class PaletteScreen extends StatefulWidget {
  const PaletteScreen({Key? key}) : super(key: key);

  @override
  _PaletteScreenState createState() => _PaletteScreenState();
}

class _PaletteScreenState extends State<PaletteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: CustomDrawer(context),
      body: Center(
        child: Text('Generated palettes'),
      ),
    );
  }
}
