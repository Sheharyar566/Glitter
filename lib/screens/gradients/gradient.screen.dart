import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glitter/components/appbar.component.dart';
import 'package:glitter/components/drawer.component.dart';
import 'package:glitter/components/loader.component.dart';
import 'package:glitter/models/gradient.dart';
import 'components/gradient.component.dart';

class GradientScreen extends StatelessWidget {
  Future<List<GradientModel>> loadData() async {
    try {
      final String stringifiedData =
          await rootBundle.loadString('assets/files/gradients.json');
      final List<dynamic> jsonData = jsonDecode(stringifiedData);

      final List<GradientModel> gradientList = jsonData
          .map((item) => GradientModel.fromJSON(item as Map<String, dynamic>))
          .toList();

      return gradientList;
    } catch (e) {
      print('Error occured while loading the gradients list: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        titleText: 'Gradients',
      ),
      drawer: CustomDrawer(context),
      body: FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
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
                    Text(
                      'Coming Soon',
                      style: Theme.of(context).primaryTextTheme.bodyText2,
                    ),
                  ],
                ),
              );
            } else {
              final List<GradientModel> data =
                  snapshot.data as List<GradientModel>;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return GradientComponent(
                    name: data[index].name,
                    colors: data[index].colors,
                  );
                },
              );
            }
          } else {
            return Loader();
          }
        },
      ),
    );
  }
}
