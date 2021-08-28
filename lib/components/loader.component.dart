import 'package:flutter/material.dart';
import 'package:glitter_pro/utils/db.util.dart';
import 'package:glitter_pro/utils/themes.util.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: dbService.darkMode
                    ? Themes.darkPrimaryColor
                    : Themes.primaryColor,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
