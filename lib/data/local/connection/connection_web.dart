import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Membuka database Drift di platform Web (IndexedDB / WASM)
QueryExecutor connect() {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'nikahin_web_db',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    return result.resolvedExecutor;
  });
}
