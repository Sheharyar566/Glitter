import 'package:flutter/material.dart';
import 'package:glitter/enums/screens.enum.dart';
import 'package:glitter/utils/db.util.dart';

class CustomDrawer extends Drawer {
  final BuildContext context;
  CustomDrawer(this.context);

  @override
  Widget? get child => ListView(
        children: [
          ListTile(
            title: Text(
              'My Favorite Colors',
              style: Theme.of(context)
                  .primaryTextTheme
                  .bodyText2
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            leading: Icon(
              Icons.favorite,
              color: Color(0xFFFF374C),
            ),
            onTap: () {
              Navigator.pushNamed(context, Screen.favorites);
            },
          ),
          ListTile(
            title: Text(
              'My Favorite Palettes',
              style: Theme.of(context)
                  .primaryTextTheme
                  .bodyText2
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            leading: Icon(
              Icons.palette_rounded,
              color: Color(0xFF563A45),
            ),
            onTap: () {
              Navigator.pushNamed(context, Screen.palettes);
            },
          ),
          ValueListenableBuilder(
            valueListenable: dbService.darkModeListenable,
            builder: (context, box, widget) {
              return SwitchListTile(
                title: Text(
                  'Dark Mode',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .bodyText2
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                value: dbService.darkMode,
                onChanged: (value) {
                  dbService.darkMode = value;
                },
              );
            },
          ),
        ],
      );
}
