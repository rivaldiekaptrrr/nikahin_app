import 'package:flutter_test/flutter_test.dart';
import 'package:nikahin_app/shared/utils/performance_utils.dart';

void main() {
  group('PerformanceUtils Tests', () {
    test('Debouncer only executes latest action after delay', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 50));
      int executionCount = 0;
      String latestValue = '';

      debouncer.run(() {
        executionCount++;
        latestValue = 'first';
      });

      debouncer.run(() {
        executionCount++;
        latestValue = 'second';
      });

      debouncer.run(() {
        executionCount++;
        latestValue = 'final';
      });

      expect(executionCount, 0);
      await Future.delayed(const Duration(milliseconds: 70));
      expect(executionCount, 1);
      expect(latestValue, 'final');

      debouncer.dispose();
    });

    test('Throttler blocks rapid repeated calls within throttle window', () {
      final throttler = Throttler(throttleDuration: const Duration(milliseconds: 100));
      int callCount = 0;

      throttler.run(() => callCount++);
      throttler.run(() => callCount++);
      throttler.run(() => callCount++);

      expect(callCount, 1);
    });

    test('PerformanceMonitor measures execution safely', () async {
      final result = await PerformanceMonitor.measure('Sample Operation', () async {
        await Future.delayed(const Duration(milliseconds: 10));
        return 42;
      });

      expect(result, 42);
    });
  });
}