import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'palette.g.dart';

@HiveType(typeId: 1)
class Palette {
  @HiveField(0)
  String id = Uuid().v4();

  @HiveField(1)
  String name;

  @HiveField(2)
  List<String> colors;

  Palette({required this.name, required this.colors});
}
