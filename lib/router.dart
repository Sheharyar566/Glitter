import 'package:flutter/material.dart';
import 'package:glitter/screens/generator/random.screen.dart';
import 'package:glitter/screens/image/image.screen.dart';
import 'package:glitter/screens/wheel/wheel.screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.palette),
            ),
            label: 'Random Palette',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.image),
            ),
            label: 'Image Palette',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.format_color_reset_rounded),
            ),
            label: 'Color Wheel',
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: [
          RandomScreen(),
          ImageScreen(),
          WheelScreen(),
        ],
      ),
    );
  }
}
