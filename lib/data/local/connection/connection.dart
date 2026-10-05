import 'package:drift/drift.dart';

import 'connection_unsupported.dart'
    if (dart.library.io) 'connection_native.dart'
    if (dart.library.js_interop || dart.library.html) 'connection_web.dart';

/// Membuka koneksi database Drift yang kompatibel untuk seluruh platform (Android, iOS, Windows, macOS, Linux, Web)
QueryExecutor openConnection() => connect();
