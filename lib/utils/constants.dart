// App-wide constants for Smart Grocery Tracker.

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Smart Grocery Tracker';
  static const String appVersion = '1.0.0';

  // Food Categories
  static const List<String> foodCategories = [
    'Fruits',
    'Vegetables',
    'Dairy',
    'Meat & Poultry',
    'Seafood',
    'Bakery',
    'Beverages',
    'Snacks',
    'Frozen',
    'Canned Goods',
    'Condiments',
    'Grains & Pasta',
    'Other',
  ];

  // Expiry Thresholds (in days)
  static const int expiringSoonDays = 3;

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String foodItemsCollection = 'food_items';
}
