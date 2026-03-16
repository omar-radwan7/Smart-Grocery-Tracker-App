import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_grocery_tracker/models/food_item.dart';
import 'package:smart_grocery_tracker/providers/locale_provider.dart';
import 'package:smart_grocery_tracker/utils/app_strings.dart';
import 'package:smart_grocery_tracker/utils/app_theme.dart';
import 'package:smart_grocery_tracker/utils/constants.dart';
import 'package:smart_grocery_tracker/utils/expiry_helper.dart';

/// Grid-style food card with colored header and clean layout.
class FoodCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const FoodCard({
    super.key,
    required this.item,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleProvider>().languageCode;
    final s = AppStrings(lang);
    final status = item.expiryStatus;
    final statusColor = ExpiryHelper.statusColor(status);
    final tint = AppTheme.categoryTint(item.category);
    final isExpired = status == ExpiryStatus.expired;
    final dateText = DateFormat('MMM dd').format(item.expiryDate);

    // Translated display names
    final displayName = AppConstants.itemDisplay(item.name, lang);
    final displayCategory = AppConstants.categoryDisplay(item.category, lang);

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showDeleteSheet(context, s, displayName),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(AppTheme.rLg),
          boxShadow: AppTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Top image section ───
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  // Background with subtle tint
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: tint.withAlpha(38),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                  ),
                  // Centered Item Image
                  Positioned.fill(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          AppTheme.itemImagePath(item.name, item.category),
                          fit: BoxFit.cover,
                        ),
                        if (isExpired)
                          Container(
                            color: Colors.white.withAlpha(160),
                          ),
                      ],
                    ),
                  ),
                  // Quantity badge (top-right)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'x${item.quantity}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Bottom info section ───
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name (translated)
                    Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isExpired ? AppTheme.textLight : AppTheme.textDark,
                        decoration: isExpired ? TextDecoration.lineThrough : null,
                        decorationColor: AppTheme.textLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Category (translated)
                    Text(
                      displayCategory,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Status pill
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withAlpha(18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                dateText,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteSheet(BuildContext context, AppStrings s, String displayName) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.surfaceGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${s.get('deleteConfirm')} "$displayName"?',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: AppTheme.surfaceGrey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.rSm),
                      ),
                    ),
                    child: Text(s.get('cancel'),
                        style: const TextStyle(color: AppTheme.textMedium)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onDelete?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.expiredRed,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.rSm),
                      ),
                    ),
                    child: Text(s.get('delete')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
