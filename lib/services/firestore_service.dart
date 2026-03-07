import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_grocery_tracker/models/food_item.dart';
import 'package:smart_grocery_tracker/utils/constants.dart';

/// Service handling all Firestore CRUD operations for food items.
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Returns the food items collection reference for a specific user.
  CollectionReference<Map<String, dynamic>> _foodItemsRef(String uid) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection(AppConstants.foodItemsCollection);
  }

  /// Updates the user's email document in the users collection.
  Future<void> updateUserEmail(String uid, String email) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .set({'email': email}, SetOptions(merge: true));
  }

  /// Streams all food items for the given user, ordered by expiry date.
  Stream<List<FoodItem>> streamFoodItems(String uid) {
    return _foodItemsRef(uid)
        .orderBy('expiryDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FoodItem.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Adds a new food item to Firestore.
  Future<void> addFoodItem(String uid, FoodItem item) async {
    await _foodItemsRef(uid).add(item.toMap());
  }

  /// Updates an existing food item in Firestore.
  Future<void> updateFoodItem(String uid, FoodItem item) async {
    await _foodItemsRef(uid).doc(item.id).update(item.toMap());
  }

  /// Deletes a food item from Firestore.
  Future<void> deleteFoodItem(String uid, String itemId) async {
    await _foodItemsRef(uid).doc(itemId).delete();
  }

  /// Gets a single food item by its ID.
  Future<FoodItem?> getFoodItem(String uid, String itemId) async {
    final doc = await _foodItemsRef(uid).doc(itemId).get();
    if (doc.exists) {
      return FoodItem.fromMap(doc.data()!, doc.id);
    }
    return null;
  }
}
