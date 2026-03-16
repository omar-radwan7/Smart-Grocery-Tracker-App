import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_grocery_tracker/providers/locale_provider.dart';
import 'package:smart_grocery_tracker/utils/app_strings.dart';
import 'package:smart_grocery_tracker/utils/app_theme.dart';
import 'package:smart_grocery_tracker/utils/constants.dart';

/// Clean horizontal filter chips — text only, no emojis.
/// Shows translated category names based on current locale.
class CategoryFilterBar extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const CategoryFilterBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleProvider>().languageCode;
    final s = AppStrings(lang);

    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: AppConstants.foodCategories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _chip(s.get('all'), null);
          }
          final catKey = AppConstants.foodCategories[index - 1];
          final catDisplay = AppConstants.categoryDisplay(catKey, lang);
          return _chip(catDisplay, catKey);
        },
      ),
    );
  }

  Widget _chip(String label, String? value) {
    final isSelected =
        (value == null && selectedCategory == null) ||
        (value != null && selectedCategory == value);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => onCategorySelected(
            isSelected && value != null ? null : value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.textDark : AppTheme.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? null
                : Border.all(color: AppTheme.surfaceGrey, width: 1),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppTheme.textMedium,
            ),
          ),
        ),
      ),
    );
  }
}
