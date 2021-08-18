import 'package:flutter/material.dart';
import 'package:glitter/components/appbar.component.dart';
import 'package:glitter/components/drawer.component.dart';

class WheelScreen extends StatelessWidget {
  const WheelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        titleText: 'Color wheel',
      ),
      drawer: CustomDrawer(context),
      body: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.warning_rounded,
                color: Colors.orange,
                size: 45,
              ),
              SizedBox(
                height: 10,
              ),
              Text('Coming Soon'),
            ],
          ),
        ),
      ),
    );
  }
}
