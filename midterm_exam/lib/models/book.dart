import 'package:isar/isar.dart';

part 'book.g.dart';

@collection
class Book {
  Id id = Isar.autoIncrement;

  late String title;
  late String story;
  late String imageURL;
  late String year;
  late int authorId;

  Book copyWith({
    Id? id,
    String? title,
    String? story,
    String? imageURL,
    String? year,
    int? authorId,
  }) {
    return Book()
      ..id = id ?? this.id
      ..title = title ?? this.title
      ..story = story ?? this.story
      ..imageURL = imageURL ?? this.imageURL
      ..year = year ?? this.year
      ..authorId = authorId ?? this.authorId;
  }
}
