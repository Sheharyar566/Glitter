import 'package:hive/hive.dart';
part 'palette.g.dart';

@HiveType(typeId: 1)
class Palette {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<String> colors;

  Palette({required this.id, required this.name, required this.colors});
}
