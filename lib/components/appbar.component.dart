import 'package:flutter/material.dart';
import 'package:glitter/enums/screens.enum.dart';

class CustomAppBar extends AppBar {
  final BuildContext context;
  final String titleText;
  final List<Widget>? actionsList;
  CustomAppBar({
    required this.context,
    required this.titleText,
    this.actionsList,
  });

  @override
  double? get leadingWidth => 40;

  @override
  Widget? get title => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/icon.png',
            fit: BoxFit.contain,
            width: 25,
            height: 25,
          ),
          SizedBox(
            width: 10,
          ),
          Text(this.titleText),
        ],
      );

  @override
  Widget? get leading => Navigator.canPop(context)
      ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.popUntil(
                context,
                ModalRoute.withName(Screen.home),
              );
            }
          },
        )
      : null;

  @override
  List<Widget>? get actions => this.actionsList;
}
