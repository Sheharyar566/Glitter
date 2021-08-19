import 'package:flutter/material.dart';
import 'package:glitter/enums/screens.enum.dart';
import 'package:glitter/screens/editor/editor.screen.dart';
import 'package:glitter/utils/const.util.dart';
import 'package:glitter/utils/db.util.dart';
import 'package:glitter/utils/themes.util.dart';

class CustomDrawer extends Drawer {
  final BuildContext context;
  CustomDrawer(this.context);

  @override
  Widget? get child => Container(
        color: dbService.darkMode ? Themes.darkBackground : Colors.white,
        child: ListView(
          children: [
            ListTile(
              title: Text('My Favorite Colors',
                  style: Theme.of(context).primaryTextTheme.bodyText2),
              leading: Icon(
                Icons.favorite,
                color: Color(0xFFFF374C),
              ),
              onTap: () {
                Navigator.pushNamed(context, Screen.favorites);
              },
            ),
            ListTile(
              title: Text('My Favorite Palettes',
                  style: Theme.of(context).primaryTextTheme.bodyText2),
              leading: Icon(
                Icons.palette_rounded,
                color: Color(0xFF563A45),
              ),
              onTap: () {
                Navigator.pushNamed(context, Screen.palettes);
              },
            ),
            ListTile(
              title: Text('Palette Editor',
                  style: Theme.of(context).primaryTextTheme.bodyText2),
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
                    style: Theme.of(context).primaryTextTheme.bodyText2,
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
                    isDarkMode
                        ? Icons.dark_mode_rounded
                        : Icons.wb_sunny_rounded,
                    color: isDarkMode ? Colors.white : Colors.yellow,
                  ),
                  title: Text(
                    'Dark Mode',
                    style: Theme.of(context).primaryTextTheme.bodyText2,
                  ),
                  trailing: Switch(
                    value: dbService.darkMode,
                    onChanged: (value) {
                      dbService.darkMode = value;
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'About',
                style: Theme.of(context).primaryTextTheme.bodyText2,
              ),
              leading: Icon(
                Icons.info,
                color: dbService.darkMode ? Colors.white : Themes.primaryColor,
              ),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: appName,
                  applicationVersion: '2.0.0',
                  applicationIcon: Image.asset(
                    'assets/icons/icon.png',
                    width: 25,
                    height: 25,
                  ),
                  applicationLegalese: 'All rights reserved - Dev404',
                  children: [
                    Text(
                      "Icons made by Good Ware from Flaticon",
                      style: Theme.of(context).primaryTextTheme.bodyText2,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
}
