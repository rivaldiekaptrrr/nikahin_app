import 'package:drift/drift.dart';

import 'connection_unsupported.dart'
    if (dart.library.js_interop) 'connection_web.dart'
    if (dart.library.html) 'connection_web.dart'
    if (dart.library.io) 'connection_native.dart';

/// Membuka koneksi database Drift yang kompatibel untuk seluruh platform (Android, iOS, Windows, macOS, Linux, Web)
QueryExecutor openConnection() => connect();
