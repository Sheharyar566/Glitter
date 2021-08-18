import 'package:flutter/material.dart';
import 'package:glitter/enums/screens.enum.dart';
import 'package:glitter/router.dart';
import 'package:glitter/screens/editor/editor.screen.dart';
import 'package:glitter/screens/favorites/favorites.screen.dart';
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
    return ValueListenableBuilder(
      valueListenable: dbService.darkModeListenable,
      builder: (context, _, child) {
        return MaterialApp(
          theme: Themes.lightTheme,
          darkTheme: ThemeData.dark(),
          themeMode: dbService.darkMode ? ThemeMode.dark : ThemeMode.system,
          debugShowCheckedModeBanner: false,
          routes: {
            Screen.home: (context) => MainPage(),
            Screen.editor: (context) => PaletteEditor(),
            Screen.favorites: (context) => FavoriteScreen(),
            Screen.palettes: (context) => PaletteScreen(),
          },
          initialRoute: Screen.palettes,
        );
      },
    );
  }
}
