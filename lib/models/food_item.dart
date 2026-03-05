import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_grocery_tracker/utils/expiry_helper.dart';

/// Model representing a food item in the tracker.
class FoodItem {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final DateTime expiryDate;
  final String? imageUrl;
  final DateTime createdAt;

  FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.expiryDate,
    this.imageUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Computed property: the current expiry status.
  ExpiryStatus get expiryStatus => ExpiryHelper.getStatus(expiryDate);

  /// Computed property: days remaining until expiry.
  int get daysRemaining => ExpiryHelper.daysRemaining(expiryDate);

  /// Creates a [FoodItem] from a Firestore document.
  factory FoodItem.fromMap(Map<String, dynamic> map, String documentId) {
    return FoodItem(
      id: documentId,
      name: map['name'] ?? '',
      category: map['category'] ?? 'Other',
      quantity: map['quantity'] ?? 1,
      expiryDate: (map['expiryDate'] as Timestamp).toDate(),
      imageUrl: map['imageUrl'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// Converts this [FoodItem] to a Firestore-compatible map.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'quantity': quantity,
      'expiryDate': Timestamp.fromDate(expiryDate),
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Creates a copy with the given fields replaced.
  FoodItem copyWith({
    String? id,
    String? name,
    String? category,
    int? quantity,
    DateTime? expiryDate,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      expiryDate: expiryDate ?? this.expiryDate,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'FoodItem(id: $id, name: $name, category: $category, '
        'quantity: $quantity, expiryDate: $expiryDate)';
  }
}
