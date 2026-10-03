import 'dart:async';
import 'package:flutter/foundation.dart';

/// Debouncer to delay execution until user stops typing or triggering action
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 300)});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

/// Throttler to limit repeated actions (e.g. rapid double-clicks on buttons)
class Throttler {
  final Duration throttleDuration;
  DateTime? _lastExecution;

  Throttler({this.throttleDuration = const Duration(milliseconds: 500)});

  bool canExecute() {
    final now = DateTime.now();
    if (_lastExecution == null || now.difference(_lastExecution!) > throttleDuration) {
      _lastExecution = now;
      return true;
    }
    return false;
  }

  void run(VoidCallback action) {
    if (canExecute()) {
      action();
    }
  }
}

/// Lightweight execution timer for measuring latency and DB query performance in debug mode
class PerformanceMonitor {
  static Future<T> measure<T>(String operationName, Future<T> Function() operation) async {
    if (!kDebugMode) return await operation();

    final stopwatch = Stopwatch()..start();
    try {
      final result = await operation();
      stopwatch.stop();
      debugPrint('⚡ [PERF]  completed in  ms');
      return result;
    } catch (e) {
      stopwatch.stop();
      debugPrint('❌ [PERF ERROR]  failed after  ms: ');
      rethrow;
    }
  }
}