import 'package:isar/isar.dart';

part 'song.g.dart';

@collection
class Song {
  Id id = Isar.autoIncrement;

  late String title;
  late int artistId;
  String? pathImage;

  Song copyWith({Id? id, String? title, int? artistId, String? pathImage}) {
    return Song()
      ..id = id ?? this.id
      ..title = title ?? this.title
      ..artistId = artistId ?? this.artistId
      ..pathImage = pathImage ?? this.pathImage;
  }
}
