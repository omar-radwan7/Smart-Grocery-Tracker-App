import 'package:flutter_test/flutter_test.dart';
import 'package:smart_grocery_tracker/utils/expiry_helper.dart';
import 'package:smart_grocery_tracker/utils/app_strings.dart';

void main() {
  final s = AppStrings('en');

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

    test('returns expiringSoon for dates within 5 days', () {
      final inThreeDays = DateTime.now().add(const Duration(days: 3));
      expect(
        ExpiryHelper.getStatus(inThreeDays),
        ExpiryStatus.expiringSoon,
      );
    });

    test('returns normal for dates more than 5 days away', () {
      final inSixDays = DateTime.now().add(const Duration(days: 6));
      expect(
        ExpiryHelper.getStatus(inSixDays),
        ExpiryStatus.normal,
      );
    });
  });

  group('ExpiryHelper.remainingText', () {
    test('formats expired message correctly', () {
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
      expect(
        ExpiryHelper.remainingText(twoDaysAgo, s),
        'Expired 2 day(s) ago',
      );
    });

    test('formats expired message for one day correctly', () {
      final oneDayAgo = DateTime.now().subtract(const Duration(days: 1));
      expect(
        ExpiryHelper.remainingText(oneDayAgo, s),
        'Expired 1 day(s) ago',
      );
    });

    test('shows "Expires today" for today', () {
      final today = DateTime.now();
      expect(
        ExpiryHelper.remainingText(today, s),
        'Expires today',
      );
    });

    test('shows "Expires tomorrow" for one day ahead', () {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      expect(
        ExpiryHelper.remainingText(tomorrow, s),
        'Expires tomorrow',
      );
    });

    test('shows generic days remaining for > 1 day ahead', () {
      final inFourDays = DateTime.now().add(const Duration(days: 4));
      expect(
        ExpiryHelper.remainingText(inFourDays, s),
        '4 days remaining',
      );
    });
  });
}

