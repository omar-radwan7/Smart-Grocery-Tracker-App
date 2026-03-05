import 'package:flutter/material.dart';
import 'package:smart_grocery_tracker/utils/app_theme.dart';
import 'package:smart_grocery_tracker/utils/expiry_helper.dart';

/// Modern pill-shaped expiry status badge.
class ExpiryBadge extends StatelessWidget {
  final ExpiryStatus status;
  final bool compact;

  const ExpiryBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = ExpiryHelper.statusColor(status);
    final label = ExpiryHelper.statusLabel(status);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 14,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(AppTheme.rXl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 6 : 8,
            height: compact ? 6 : 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: compact ? 5 : 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
