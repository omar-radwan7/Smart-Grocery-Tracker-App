import 'package:flutter_test/flutter_test.dart';
import 'package:smart_grocery_tracker/utils/expiry_helper.dart';

void main() {
  group('ExpiryHelper.getStatus', () {
    test('returns expired for dates in the past', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(
        ExpiryHelper.getStatus(yesterday),
        ExpiryStatus.expired,
      );
    });

    test('returns expiresToday for today', () {
      final today = DateTime.now();
      expect(
        ExpiryHelper.getStatus(today),
        ExpiryStatus.expiresToday,
      );
    });

    test('returns expiringSoon for dates within 3 days', () {
      final inThreeDays = DateTime.now().add(const Duration(days: 3));
      expect(
        ExpiryHelper.getStatus(inThreeDays),
        ExpiryStatus.expiringSoon,
      );
    });

    test('returns normal for dates more than 3 days away', () {
      final inFiveDays = DateTime.now().add(const Duration(days: 5));
      expect(
        ExpiryHelper.getStatus(inFiveDays),
        ExpiryStatus.normal,
      );
    });
  });

  group('ExpiryHelper.remainingText', () {
    test('formats expired message with plural correctly', () {
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
      expect(
        ExpiryHelper.remainingText(twoDaysAgo),
        'Expired 2 days ago',
      );
    });

    test('formats expired message with singular correctly', () {
      final oneDayAgo = DateTime.now().subtract(const Duration(days: 1));
      expect(
        ExpiryHelper.remainingText(oneDayAgo),
        'Expired 1 day ago',
      );
    });

    test('shows \"Expires today\" for today', () {
      final today = DateTime.now();
      expect(
        ExpiryHelper.remainingText(today),
        'Expires today',
      );
    });

    test('shows \"Expires tomorrow\" for one day ahead', () {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      expect(
        ExpiryHelper.remainingText(tomorrow),
        'Expires tomorrow',
      );
    });

    test('shows generic days remaining for > 1 day ahead', () {
      final inFourDays = DateTime.now().add(const Duration(days: 4));
      expect(
        ExpiryHelper.remainingText(inFourDays),
        '4 days remaining',
      );
    });
  });
}

