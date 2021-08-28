import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glitter/components/appbar.component.dart';
import 'package:glitter/components/drawer.component.dart';
import 'package:glitter/components/loader.component.dart';
import 'package:glitter/models/gradient.dart';
import 'package:glitter/screens/gradients/components/color.component.dart';
import 'package:glitter/utils/functions.util.dart';
import 'components/gradient.component.dart';

class GradientScreen extends StatefulWidget {
  @override
  _GradientScreenState createState() => _GradientScreenState();
}

class _GradientScreenState extends State<GradientScreen> {
  late final StreamController<List<Color>> controller;

  @override
  void initState() {
    super.initState();
    controller = StreamController();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  Future<List<GradientModel>> loadData() async {
    try {
      final String stringifiedData =
          await rootBundle.loadString('assets/files/gradients.json');
      final List<dynamic> jsonData = jsonDecode(stringifiedData);

      final List<GradientModel> gradientList = jsonData
          .map((item) => GradientModel.fromJSON(item as Map<String, dynamic>))
          .toList();

      controller.add(
        gradientList[0].colors.map((color) => rgbToColor(color)).toList(),
      );

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
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            flex: 2,
            child: StreamBuilder<List<Color>>(
              stream: controller.stream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Loader();
                }

                List<Color> colors = snapshot.data!;

                return Flex(
                  direction: Axis.vertical,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.favorite),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.download),
                        ),
                      ],
                    ),
                    Expanded(
                      child: AnimatedContainer(
                        duration: Duration(
                          milliseconds: 350,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: colors,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10.0,
                      children: colors
                          .map((color) => GradientColor(color: color))
                          .toList(),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
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

                    return GridView.builder(
                      padding: const EdgeInsets.all(20),
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 1 / 1,
                      ),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return GradientComponent(
                          controller: controller,
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
          ),
        ],
      ),
    );
  }
}
