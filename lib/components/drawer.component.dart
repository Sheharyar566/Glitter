import 'package:flutter/material.dart';
import 'package:glitter/enums/screens.enum.dart';
import 'package:glitter/screens/editor/editor.screen.dart';
import 'package:glitter/utils/db.util.dart';

class CustomDrawer extends Drawer {
  final BuildContext context;
  CustomDrawer(this.context);

  @override
  Widget? get child => ListView(
        children: [
          ListTile(
            title: Text('My Favorite Colors'),
            leading: Icon(
              Icons.favorite,
              color: Color(0xFFFF374C),
            ),
            onTap: () {
              Navigator.pushNamed(context, Screen.favorites);
            },
          ),
          ListTile(
            title: Text('My Favorite Palettes'),
            leading: Icon(
              Icons.palette_rounded,
              color: Color(0xFF563A45),
            ),
            onTap: () {
              Navigator.pushNamed(context, Screen.palettes);
            },
          ),
          ListTile(
            title: Text('Palette Editor'),
            leading: Icon(Icons.edit),
            onTap: () {
              Navigator.of(context).pushNamed(
                Screen.editor,
                arguments: EditorParams(
                  isCustom: true,
                ),
              );
            },
            trailing: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.red,
              ),
              width: 30,
              height: 30,
              child: Center(
                child: Text(
                  dbService.getCustomPalette().length.toString(),
                  style: Theme.of(context)
                      .primaryTextTheme
                      .bodyText2
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: dbService.darkModeListenable,
            builder: (context, box, widget) {
              final bool isDarkMode = dbService.darkMode;

              return ListTile(
                leading: Icon(
                  isDarkMode ? Icons.dark_mode_rounded : Icons.wb_sunny_rounded,
                  color: isDarkMode ? Colors.white : Colors.yellow,
                ),
                title: Text('Dark Mode'),
                trailing: Switch(
                  value: dbService.darkMode,
                  onChanged: (value) {
                    dbService.darkMode = value;
                  },
                ),
              );
            },
          ),
        ],
      );
}
