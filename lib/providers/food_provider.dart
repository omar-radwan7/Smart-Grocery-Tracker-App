import 'package:flutter/material.dart';
import 'package:smart_grocery_tracker/models/food_item.dart';
import 'package:smart_grocery_tracker/services/firestore_service.dart';
import 'package:smart_grocery_tracker/utils/expiry_helper.dart';

/// Provider managing food items state and Firestore interaction.
class FoodProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<FoodItem> _foodItems = [];
  String? _selectedCategory;
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  List<FoodItem> get foodItems => _filteredItems;
  List<FoodItem> get allItems => _foodItems;
  String? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Returns food items filtered by category and search query.
  List<FoodItem> get _filteredItems {
    List<FoodItem> items = List.from(_foodItems);

    // Apply category filter
    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      items = items.where((item) => item.category == _selectedCategory).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      items = items
          .where((item) =>
              item.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return items;
  }

  /// Count of items by expiry status.
  int get normalCount =>
      _foodItems.where((i) => i.expiryStatus == ExpiryStatus.normal).length;
  int get expiringSoonCount =>
      _foodItems.where((i) => i.expiryStatus == ExpiryStatus.expiringSoon).length;
  int get expiresTodayCount =>
      _foodItems.where((i) => i.expiryStatus == ExpiryStatus.expiresToday).length;
  int get expiredCount =>
      _foodItems.where((i) => i.expiryStatus == ExpiryStatus.expired || i.expiryStatus == ExpiryStatus.expiresToday).length;

  /// Set the selected category filter.
  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Set the search query.
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Clear all filters.
  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = '';
    notifyListeners();
  }

  /// Subscribe to Firestore food items stream for the given user.
  void listenToFoodItems(String uid) {
    _isLoading = true;
    notifyListeners();

    _firestoreService.streamFoodItems(uid).listen(
      (items) {
        _foodItems = items;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Failed to load food items.';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Add a new food item.
  Future<bool> addFoodItem(String uid, FoodItem item) async {
    try {
      await _firestoreService.addFoodItem(uid, item);
      return true;
    } catch (e) {
      _error = 'Failed to add food item.';
      notifyListeners();
      return false;
    }
  }

  /// Update an existing food item.
  Future<bool> updateFoodItem(String uid, FoodItem item) async {
    try {
      await _firestoreService.updateFoodItem(uid, item);
      return true;
    } catch (e) {
      _error = 'Failed to update food item.';
      notifyListeners();
      return false;
    }
  }

  /// Delete a food item.
  Future<bool> deleteFoodItem(String uid, String itemId) async {
    try {
      await _firestoreService.deleteFoodItem(uid, itemId);
      return true;
    } catch (e) {
      _error = 'Failed to delete food item.';
      notifyListeners();
      return false;
    }
  }

  /// Clear error message.
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
