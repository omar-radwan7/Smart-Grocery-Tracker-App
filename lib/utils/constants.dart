// App-wide constants for Smart Grocery Tracker.

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Smart Grocery Tracker';
  static const String appVersion = '1.0.0';

  // Food Categories (internal keys — always English)
  static const List<String> foodCategories = [
    'Fruits',
    'Vegetables',
    'Dairy',
    'Meat & Poultry',
    'Seafood',
  ];

  static const Map<String, List<String>> categoryItems = {
    'Fruits': ['Apple', 'Banana', 'Orange', 'Strawberry', 'Grape', 'Mango', 'Watermelon', 'Pineapple', 'Lemon', 'Peach', 'Kiwi', 'Avocado'],
    'Vegetables': ['Tomato', 'Potato', 'Onion', 'Carrot', 'Cucumber', 'Bell Pepper', 'Broccoli', 'Spinach', 'Lettuce', 'Garlic', 'Mushroom', 'Cabbage'],
    'Dairy': ['Milk', 'Cheese', 'Yogurt', 'Butter', 'Cream', 'Eggs'],
    'Meat & Poultry': ['Chicken Breast', 'Beef', 'Pork', 'Turkey', 'Lamb', 'Sausage', 'Bacon'],
    'Seafood': ['Salmon', 'Tuna', 'Shrimp'],
    'Bakery': ['Bread', 'Bagels', 'Croissants', 'Muffins', 'Cake'],
  };

  // ── German Translations ──

  /// Maps English category keys → German display names
  static const Map<String, String> categoryNamesDe = {
    'Fruits': 'Obst',
    'Vegetables': 'Gemüse',
    'Dairy': 'Milchprodukte',
    'Meat & Poultry': 'Fleisch & Geflügel',
    'Seafood': 'Meeresfrüchte',
    'Bakery': 'Bäckerei',
  };

  /// Maps English item names → German display names
  static const Map<String, String> itemNamesDe = {
    // Fruits
    'Apple': 'Apfel',
    'Banana': 'Banane',
    'Orange': 'Orange',
    'Strawberry': 'Erdbeere',
    'Grape': 'Traube',
    'Mango': 'Mango',
    'Watermelon': 'Wassermelone',
    'Pineapple': 'Ananas',
    'Lemon': 'Zitrone',
    'Peach': 'Pfirsich',
    'Kiwi': 'Kiwi',
    'Avocado': 'Avocado',
    // Vegetables
    'Tomato': 'Tomate',
    'Potato': 'Kartoffel',
    'Onion': 'Zwiebel',
    'Carrot': 'Karotte',
    'Cucumber': 'Gurke',
    'Bell Pepper': 'Paprika',
    'Broccoli': 'Brokkoli',
    'Spinach': 'Spinat',
    'Lettuce': 'Salat',
    'Garlic': 'Knoblauch',
    'Mushroom': 'Pilz',
    'Cabbage': 'Kohl',
    // Dairy
    'Milk': 'Milch',
    'Cheese': 'Käse',
    'Yogurt': 'Joghurt',
    'Butter': 'Butter',
    'Cream': 'Sahne',
    'Eggs': 'Eier',
    // Meat & Poultry
    'Chicken Breast': 'Hähnchenbrust',
    'Beef': 'Rindfleisch',
    'Pork': 'Schweinefleisch',
    'Turkey': 'Truthahn',
    'Lamb': 'Lamm',
    'Sausage': 'Wurst',
    'Bacon': 'Speck',
    // Seafood
    'Salmon': 'Lachs',
    'Tuna': 'Thunfisch',
    'Shrimp': 'Garnele',
    // Bakery
    'Bread': 'Brot',
    'Bagels': 'Bagels',
    'Croissants': 'Croissants',
    'Muffins': 'Muffins',
    'Cake': 'Kuchen',
    // Misc
    'Misc Item': 'Sonstiges',
  };

  /// Returns the translated category name for display.
  static String categoryDisplay(String categoryKey, String lang) {
    if (lang == 'de') return categoryNamesDe[categoryKey] ?? categoryKey;
    return categoryKey;
  }

  /// Returns the translated item name for display.
  static String itemDisplay(String itemKey, String lang) {
    if (lang == 'de') return itemNamesDe[itemKey] ?? itemKey;
    return itemKey;
  }

  // Expiry Thresholds (in days)
  static const int expiringSoonDays = 3;

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String foodItemsCollection = 'food_items';
}
