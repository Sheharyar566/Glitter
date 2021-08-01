import 'package:flutter/material.dart';
import 'package:glitter/enums/screens.enum.dart';

class CustomDrawer extends Drawer {
  final BuildContext context;
  CustomDrawer(this.context);

  @override
  Widget? get child => ListView(
        children: [
          ListTile(
            title: Text(
              'My Favorite Colors',
              style: Theme.of(context).primaryTextTheme.bodyText2,
            ),
            leading: Icon(
              Icons.favorite,
              color: Color(0xFFFF374C),
            ),
            onTap: () {
              Navigator.pushNamed(context, Screen.favorites);
            },
          ),
        ],
      );
}
