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

  static const Map<String, List<String>> categoryItems = {
    'Fruits': ['Apple', 'Banana', 'Orange', 'Strawberry', 'Grape', 'Mango', 'Watermelon', 'Pineapple', 'Lemon', 'Peach', 'Kiwi'],
    'Vegetables': ['Tomato', 'Potato', 'Onion', 'Carrot', 'Cucumber', 'Bell Pepper', 'Broccoli', 'Spinach', 'Lettuce', 'Garlic', 'Mushroom', 'Cabbage'],
    'Dairy': ['Milk', 'Cheese', 'Yogurt', 'Butter', 'Cream', 'Eggs'],
    'Meat & Poultry': ['Chicken Breast', 'Beef', 'Pork', 'Turkey', 'Lamb', 'Sausage', 'Bacon'],
    'Seafood': ['Salmon', 'Tuna', 'Shrimp', 'Cod', 'Crab', 'Tilapia'],
    'Bakery': ['Bread', 'Bagel', 'Croissant', 'Muffin', 'Cake', 'Cookies'],
    'Beverages': ['Water', 'Juice', 'Soda', 'Coffee', 'Tea'],
    'Snacks': ['Chips', 'Popcorn', 'Nuts', 'Pretzels', 'Chocolate'],
    'Frozen': ['Ice Cream', 'Frozen Pizza', 'Frozen Vegetables', 'Frozen Meals'],
    'Canned Goods': ['Canned Beans', 'Canned Corn', 'Canned Tomatoes', 'Canned Soup'],
    'Condiments': ['Ketchup', 'Mustard', 'Mayonnaise', 'Soy Sauce', 'Hot Sauce'],
    'Grains & Pasta': ['Rice', 'Pasta', 'Oats', 'Quinoa', 'Cereal'],
    'Other': [],
  };

  // Expiry Thresholds (in days)
  static const int expiringSoonDays = 3;

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String foodItemsCollection = 'food_items';
}
