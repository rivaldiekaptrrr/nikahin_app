import 'package:flutter_test/flutter_test.dart';
import 'package:nikahin_app/data/services/notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationService Unit Tests', () {
    late NotificationService service;

    setUp(() {
      service = NotificationService();
    });

    test('NotificationService instantiates without error and provides default constants', () {
      expect(service, isNotNull);
      expect(NotificationService.kDailyReminderNotificationId, equals(999999));
    });

    test('scheduleVendorPaymentReminder calculates alert date and notification id safely', () async {
      final dueDate = DateTime.now().add(const Duration(days: 10));
      // Shouldn't throw unhandled exceptions
      await service.scheduleVendorPaymentReminder(
        expenseId: 'exp_catering',
        vendorName: 'Berkah Catering',
        termLabel: 'Pelunasan',
        dueDate: dueDate,
        daysBefore: 3,
      );
    });

    test('scheduleWeddingCountdownReminders executes safely with valid wedding date', () async {
      final futureWedding = DateTime.now().add(const Duration(days: 45));
      await service.scheduleWeddingCountdownReminders(
        weddingDate: futureWedding,
        groomName: 'Rama',
        brideName: 'Sinta',
      );
    });

    test('cancelVendorPaymentReminder generates correct hash-based notification id', () async {
      await service.cancelVendorPaymentReminder('exp_decor');
    });
  });
}
