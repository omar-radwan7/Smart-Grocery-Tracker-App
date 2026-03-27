import 'package:flutter/material.dart';
import 'package:smart_grocery_tracker/utils/app_strings.dart';

/// Enum representing the expiry status of a food item.
enum ExpiryStatus {
  normal,
  expiringSoon,
  expiresToday,
  expired,
}

/// Helper class for expiry date calculations and UI styling.
class ExpiryHelper {
  ExpiryHelper._();

  /// Calculates the [ExpiryStatus] based on the expiry date.
  static ExpiryStatus getStatus(DateTime expiryDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    final difference = expiry.difference(today).inDays;

    if (difference < 0) {
      return ExpiryStatus.expired;
    } else if (difference == 0) {
      return ExpiryStatus.expiresToday;
    } else if (difference <= 5) {
      return ExpiryStatus.expiringSoon;
    } else {
      return ExpiryStatus.normal;
    }
  }

  /// Returns the number of days remaining until expiry.
  /// Negative values indicate the item has already expired.
  static int daysRemaining(DateTime expiryDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return expiry.difference(today).inDays;
  }

  /// Returns the display label for the given [ExpiryStatus].
  static String statusLabel(ExpiryStatus status) {
    switch (status) {
      case ExpiryStatus.normal:
        return 'Fresh';
      case ExpiryStatus.expiringSoon:
        return 'Expiring Soon';
      case ExpiryStatus.expiresToday:
        return 'Expires Today!';
      case ExpiryStatus.expired:
        return 'Expired';
    }
  }


  /// Returns the display text for remaining days.
  static String remainingText(DateTime expiryDate, AppStrings s) {
    final days = daysRemaining(expiryDate);
    if (days < 0) {
      return s.get('expiredAgo').replaceAll('{n}', '${-days}');
    } else if (days == 0) {
      return s.get('expiresToday');
    } else if (days == 1) {
      return s.get('expiresTomorrow');
    } else {
      return s.get('daysRemaining').replaceAll('{n}', '$days');
    }
  }

  /// Returns the badge color for the given [ExpiryStatus].
  static Color statusColor(ExpiryStatus status) {
    switch (status) {
      case ExpiryStatus.normal:
        return const Color(0xFF2E7D32); // dark green
      case ExpiryStatus.expiringSoon:
        return const Color(0xFFFF8F00); // amber
      case ExpiryStatus.expiresToday:
        return const Color(0xFFE65100); // deep orange
      case ExpiryStatus.expired:
        return const Color(0xFFC62828); // red
    }
  }

  /// Returns the background color for the card based on status.
  static Color statusBackgroundColor(ExpiryStatus status) {
    switch (status) {
      case ExpiryStatus.normal:
        return const Color(0xFFE8F5E9); // light green
      case ExpiryStatus.expiringSoon:
        return const Color(0xFFFFF8E1); // light amber
      case ExpiryStatus.expiresToday:
        return const Color(0xFFFBE9E7); // light deep orange
      case ExpiryStatus.expired:
        return const Color(0xFFFFEBEE); // light red
    }
  }

  /// Returns the icon for the given [ExpiryStatus].
  static IconData statusIcon(ExpiryStatus status) {
    switch (status) {
      case ExpiryStatus.normal:
        return Icons.check_circle_outline;
      case ExpiryStatus.expiringSoon:
        return Icons.warning_amber_rounded;
      case ExpiryStatus.expiresToday:
        return Icons.notification_important;
      case ExpiryStatus.expired:
        return Icons.error_outline;
    }
  }
}
