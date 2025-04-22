import 'package:isar/isar.dart';

part 'author.g.dart';

@collection
class Author {
  Id id = Isar.autoIncrement;
  late String name;
  late String hometown;

  Author({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.hometown,
  });

  Author copyWith({int? id, String? name, String? hometown}) {
    return Author(
      id: id ?? this.id,
      name: name ?? this.name,
      hometown: hometown ?? this.hometown,
    );
  }
}
