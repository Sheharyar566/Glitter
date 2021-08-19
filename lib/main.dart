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
          darkTheme: Themes.darkTheme,
          themeMode: dbService.darkMode ? ThemeMode.dark : ThemeMode.system,
          debugShowCheckedModeBanner: false,
          routes: {
            Screen.home: (context) => const MainPage(),
            Screen.favorites: (context) => const FavoriteScreen(),
            Screen.palettes: (context) => const PaletteScreen(),
          },
          onGenerateRoute: (route) {
            print(route);
            if (route.name == Screen.editor) {
              final EditorParams _params = route.arguments as EditorParams;

              return MaterialPageRoute(
                builder: (context) {
                  return PaletteEditor(
                    isCustom: _params.isCustom,
                    palette: _params.palette,
                  );
                },
              );
            }

            return null;
          },
          initialRoute: Screen.home,
        );
      },
    );
  }
}
