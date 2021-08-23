import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

@HiveType(typeId: 2)
class GradientModel {
  @HiveField(0)
  String? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<List<int>> colors;

  GradientModel({
    this.id,
    required this.name,
    required this.colors,
  });

  factory GradientModel.fromJSON(Map<String, dynamic> data) {
    return GradientModel(
      id: Uuid().v4(),
      name: data['name'],
      colors: (data['colors'] as List<dynamic>).map((color) {
        return List<int>.from(color as List<dynamic>);
      }).toList(),
    );
  }
}
