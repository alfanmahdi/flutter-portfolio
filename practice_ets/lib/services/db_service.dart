import 'package:practice_ets/models/song.dart';
import 'package:practice_ets/models/artist.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DBService {
  static late Isar db;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    db = await Isar.open([SongSchema, ArtistSchema], directory: dir.path);
  }
}
