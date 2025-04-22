import 'package:isar/isar.dart';

part 'artist.g.dart';

@collection
class Artist {
  Id id = Isar.autoIncrement;
  late String name;

  Artist({this.id = Isar.autoIncrement, required this.name});

  Artist copyWith({int? id, String? name}) {
    return Artist(id: id ?? this.id, name: name ?? this.name);
  }
}
