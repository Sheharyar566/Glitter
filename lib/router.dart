import 'package:flutter/material.dart';
import 'package:glitter/screens/generator/random.screen.dart';
import 'package:glitter/screens/image/image.screen.dart';
import 'package:glitter/screens/wheel/wheel.screen.dart';
import 'package:glitter/utils/db.util.dart';

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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: dbService.darkMode ? Colors.black87 : Colors.grey,
              blurRadius: 5,
            ),
          ],
        ),
        child: BottomNavigationBar(
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
