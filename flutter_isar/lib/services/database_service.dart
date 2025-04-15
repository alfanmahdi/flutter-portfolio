import 'package:flutter_isar/models/todo.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static late final Isar db;
  static Future<void> setup() async {
    final appdir = await getApplicationDocumentsDirectory();
    db = await Isar.open([TodoSchema], directory: appdir.path);
  }
}
