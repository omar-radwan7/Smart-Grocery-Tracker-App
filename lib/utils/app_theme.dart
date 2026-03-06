import 'package:flutter/material.dart';

/// Premium, soft color system inspired by modern food apps.
class AppTheme {
  AppTheme._();

  // ─── Primary ───
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color darkGreen = Color(0xFF2E7D32);

  // ─── Hero gradient (soft purple-blue, like the inspiration) ───
  static const Color heroStart = Color(0xFF8B7EC8);
  static const Color heroEnd = Color(0xFFA594E4);

  // ─── Accent ───
  static const Color accentPink = Color(0xFFFF5C93);

  // ─── Backgrounds ───
  static const Color scaffoldBg = Color(0xFFF6F5FA);
  static const Color cardBg = Colors.white;
  static const Color surfaceGrey = Color(0xFFF0EDF5);

  // ─── Text ───
  static const Color textDark = Color(0xFF1D1B2E);
  static const Color textMedium = Color(0xFF5A5775);
  static const Color textLight = Color(0xFF9B97AA);
  static const Color textHint = Color(0xFFBCBAC7);

  // ─── Status ───
  static const Color freshGreen = Color(0xFF4CAF50);
  static const Color warningAmber = Color(0xFFFFA726);
  static const Color urgentOrange = Color(0xFFFF7043);
  static const Color expiredRed = Color(0xFFEF5350);

  // ─── Category card tints (soft pastels) ───
  static const Color tintGreen = Color(0xFFE8F5E9);
  static const Color tintOrange = Color(0xFFFFF3E0);
  static const Color tintBlue = Color(0xFFE3F2FD);
  static const Color tintPink = Color(0xFFFCE4EC);
  static const Color tintPurple = Color(0xFFF3E5F5);
  static const Color tintYellow = Color(0xFFFFFDE7);
  static const Color tintTeal = Color(0xFFE0F2F1);
  static const Color tintDeepOrange = Color(0xFFFBE9E7);
  static const Color tintIndigo = Color(0xFFE8EAF6);
  static const Color tintLime = Color(0xFFF1F8E9);
  static const Color tintBrown = Color(0xFFEFEBE9);
  static const Color tintCyan = Color(0xFFE0F7FA);

  // Matching accent icons for each category tint
  static const Color accentGreenIcon = Color(0xFF66BB6A);
  static const Color accentOrangeIcon = Color(0xFFFFB74D);
  static const Color accentBlueIcon = Color(0xFF64B5F6);
  static const Color accentPinkIcon = Color(0xFFF06292);
  static const Color accentPurpleIcon = Color(0xFFBA68C8);
  static const Color accentYellowIcon = Color(0xFFFFD54F);
  static const Color accentTealIcon = Color(0xFF4DB6AC);
  static const Color accentDeepOrangeIcon = Color(0xFFFF8A65);
  static const Color accentIndigoIcon = Color(0xFF7986CB);
  static const Color accentLimeIcon = Color(0xFFAED581);
  static const Color accentBrownIcon = Color(0xFFA1887F);
  static const Color accentCyanIcon = Color(0xFF4DD0E1);

  // ─── Radiuses ───
  static const double rSm = 12.0;
  static const double rMd = 16.0;
  static const double rLg = 20.0;
  static const double rXl = 28.0;

  // ─── ThemeData ───
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: scaffoldBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.light,
        surface: scaffoldBg,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(rLg),
        ),
        color: cardBg,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(rMd),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textDark,
          side: BorderSide(color: surfaceGrey, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(rMd),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceGrey,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rMd),
          borderSide: const BorderSide(color: heroStart, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textHint, fontSize: 14),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentPink,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
    );
  }

  // ─── Shadows ───
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF1D1B2E).withAlpha(8),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get heroShadow => [
        BoxShadow(
          color: heroStart.withAlpha(40),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  // ─── Category helpers ───
  static Color categoryTint(String category) {
    switch (category) {
      case 'Fruits': return tintGreen;
      case 'Vegetables': return tintLime;
      case 'Dairy': return tintBlue;
      case 'Meat & Poultry': return tintDeepOrange;
      case 'Seafood': return tintCyan;
      case 'Bakery': return tintOrange;
      case 'Beverages': return tintBrown;
      case 'Snacks': return tintYellow;
      case 'Frozen': return tintIndigo;
      case 'Canned Goods': return tintTeal;
      case 'Condiments': return tintPink;
      case 'Grains & Pasta': return tintPurple;
      default: return tintGreen;
    }
  }

  static Color categoryAccent(String category) {
    switch (category) {
      case 'Fruits': return accentGreenIcon;
      case 'Vegetables': return accentLimeIcon;
      case 'Dairy': return accentBlueIcon;
      case 'Meat & Poultry': return accentDeepOrangeIcon;
      case 'Seafood': return accentCyanIcon;
      case 'Bakery': return accentOrangeIcon;
      case 'Beverages': return accentBrownIcon;
      case 'Snacks': return accentYellowIcon;
      case 'Frozen': return accentIndigoIcon;
      case 'Canned Goods': return accentTealIcon;
      case 'Condiments': return accentPinkIcon;
      case 'Grains & Pasta': return accentPurpleIcon;
      default: return accentGreenIcon;
    }
  }

  static String categoryImagePath(String category) {
    switch (category) {
      case 'Fruits': return 'assets/images/items/fruits.png';
      case 'Vegetables': return 'assets/images/items/vegetables.png';
      case 'Dairy': return 'assets/images/items/milk.png'; // Fallback to milk if general dairy
      case 'Meat & Poultry': return 'assets/images/items/beef.png';
      case 'Seafood': return 'assets/images/items/salmon.png'; // Will need this image
      case 'Bakery': return 'assets/images/items/bakery.png'; // Will need this image
      case 'Frozen': return 'assets/images/items/frozen.png'; // Will need this image
      case 'Canned Goods': return 'assets/images/items/canned.png'; // Will need this image
      case 'Condiments': return 'assets/images/items/condiments.png'; // Will need this image
      case 'Grains & Pasta': return 'assets/images/items/grains.png'; // Will need this image
      default: return 'assets/images/items/fruits.png'; // Fallback
    }
  }

  static String itemImagePath(String itemName, String category) {
    final name = itemName.toLowerCase();
    
    // Exact items we have images for
    if (name.contains('apple')) return 'assets/images/items/apple.png';
    if (name.contains('banana')) return 'assets/images/items/banana.png';
    if (name.contains('orange')) return 'assets/images/items/orange.jpg';
    if (name.contains('grape')) return 'assets/images/items/grapes.jpg';
    if (name.contains('strawberr')) return 'assets/images/items/strawberry.jpg';
    if (name.contains('tomato')) return 'assets/images/items/tomato.png';
    if (name.contains('carrot')) return 'assets/images/items/carrot.jpg';
    if (name.contains('onion')) return 'assets/images/items/onion.png';
    if (name.contains('potato')) return 'assets/images/items/potato.jpg';
    if (name.contains('lettuce')) return 'assets/images/items/lettuce.png';

    if (name.contains('milk')) return 'assets/images/items/milk.png';
    if (name.contains('cheese')) return 'assets/images/items/cheese.png';
    if (name.contains('butter')) return 'assets/images/items/butter.png';
    if (name.contains('egg')) return 'assets/images/items/eggs.png';

    if (name.contains('beef') || name.contains('steak')) return 'assets/images/items/beef.png';
    if (name.contains('chicken')) return 'assets/images/items/chicken.png';
    if (name.contains('pork')) return 'assets/images/items/pork.png';
    if (name.contains('sausage')) return 'assets/images/items/sausage.jpg';
    if (name.contains('bacon')) return 'assets/images/items/bacon.jpg';

    if (name.contains('salmon')) return 'assets/images/items/salmon.png';
    if (name.contains('shrimp')) return 'assets/images/items/shrimp.jpg';
    if (name.contains('tuna')) return 'assets/images/items/tuna.png';

    if (name.contains('bread')) return 'assets/images/items/bread.png';
    if (name.contains('bagel')) return 'assets/images/items/bagel.jpg';
    if (name.contains('croissant')) return 'assets/images/items/croissant.jpg';
    if (name.contains('cake')) return 'assets/images/items/cake.jpg';

    if (name.contains('juice')) return 'assets/images/items/juice.png';

    // Everything else falls back to the overall category image
    return categoryImagePath(category);
  }
}
