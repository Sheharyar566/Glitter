import 'package:flutter/material.dart';
import 'package:glitter/enums/screens.enum.dart';
import 'package:glitter/screens/favorites/favorites.screen.dart';
import 'package:glitter/screens/generator/random.screen.dart';
import 'package:glitter/screens/image/image.screen.dart';
import 'package:glitter/screens/palettes/palettes.screen.dart';
import 'package:glitter/utils/db.util.dart';
import 'package:glitter/utils/themes.util.dart';

void main() async {
  await dbService.init();
  runApp(Glitter());
}

class Glitter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Themes.lightTheme,
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      routes: {
        Screen.image: (context) => ImageScreen(),
        Screen.generator: (context) => RandomScreen(),
        Screen.favorites: (context) => FavoriteScreen(),
        Screen.palettes: (context) => PaletteScreen(),
      },
      initialRoute: Screen.image,
    );
  }
}
