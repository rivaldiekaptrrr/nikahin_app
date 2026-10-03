import 'package:flutter_test/flutter_test.dart';
import 'package:nikahin_app/domain/enums/wedding_enums.dart';
import 'package:nikahin_app/domain/models/wedding_models.dart';

void main() {
  group('Wedding Models & Enums Tests', () {
    test('WeddingProfile copyWith and serialization', () {
      final profile = WeddingProfile(
        id: 'prof_123',
        groomName: 'Rivaldi',
        brideName: 'Nisa',
        weddingDate: 1790000000000,
        totalBudgetCap: 150000000.0,
        religionType: 'ISLAM',
        religionDetail: 'ISLAM',
        culturalPresetGroom: CulturalPreset.jawa.value,
        culturalPresetBride: CulturalPreset.sunda.value,
        quote: 'Menuju Sakinah Mawaddah Warahmah',
        quoteEnabled: true,
        quoteFontSize: 'SEDANG',
        quoteFontStyle: 'ITALIC',
        createdAt: 1780000000000,
      );

      expect(profile.groomName, 'Rivaldi');
      expect(profile.brideName, 'Nisa');
      expect(profile.coupleTitle, 'Rivaldi & Nisa');

      final map = profile.toFirestoreMap();
      expect(map['groomName'], 'Rivaldi');
      expect(map['totalBudgetCap'], 150000000.0);

      final reconstructed = WeddingProfile.fromFirestoreMap(map, 'prof_123');
      expect(reconstructed.id, 'prof_123');
      expect(reconstructed.brideName, 'Nisa');
      expect(reconstructed.culturalPresetGroom, CulturalPreset.jawa.value);
    });

    test('WeddingGuest serialization and RSVP', () {
      const guest = WeddingGuest(
        guestId: 'guest_1',
        weddingProfileId: 'prof_123',
        guestName: 'Budi Santoso',
        phoneNumber: '08123456789',
        groupAllocation: 'VIP',
        sessionTarget: 'KEDUANYA',
        estimatedPax: 2,
        rsvpStatus: 'HADIR',
      );

      expect(guest.groupAllocation, 'VIP');
      expect(guest.estimatedPax, 2);

      final map = guest.toFirestoreMap();
      final reconstructed = WeddingGuest.fromFirestoreMap(map, 'guest_1');
      expect(reconstructed.guestName, 'Budi Santoso');
      expect(reconstructed.rsvpStatus, 'HADIR');
    });

    test('WeddingExpense and PaymentTerm', () {
      const term = WeddingPaymentTerm(
        termId: 'term_1',
        expenseId: 'exp_1',
        termName: 'DP 30%',
        amount: 3000000.0,
        dueDate: 1790000000000,
        isPaid: true,
        paidDate: 1785000000000,
      );

      final expense = WeddingExpense(
        expenseId: 'exp_1',
        weddingProfileId: 'prof_123',
        category: ExpenseCategory.venue.value,
        title: 'Sewa Gedung Resepsi',
        totalEstimated: 10000000.0,
        totalPaid: 3000000.0,
        paidBySource: PaidBySource.bersama.value,
        paymentStatus: PaymentStatus.partialDp.value,
        createdAt: 1780000000000,
      );

      expect(expense.category, ExpenseCategory.venue.value);
      expect(term.amount, 3000000.0);
      expect(expense.totalEstimated, 10000000.0);
      expect(expense.paymentStatus, 'PARTIAL_DP');
    });
  });
}
