import 'package:isar/isar.dart';
import 'package:midterm_exam/models/author.dart';
import 'package:midterm_exam/models/book.dart';
import 'package:path_provider/path_provider.dart';

class DBService {
  static late Isar db;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    db = await Isar.open([BookSchema, AuthorSchema], directory: dir.path);
  }
}
