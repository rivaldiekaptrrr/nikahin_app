import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Membuka database SQLite secara native (Android, iOS, Windows, macOS, Linux)
QueryExecutor connect() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'nikahin.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
