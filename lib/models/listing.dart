import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String id;
  final String name;
  final String category;
  final String address;
  final String phone;
  final String description;
  final double latitude;
  final double longitude;
  final String createdBy;
  final DateTime createdAt;

  Listing({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.phone,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.createdAt,
  });

  // This converts from a Firestore document
  factory Listing.fromFirestore(String id, Map<String, dynamic> data) {
    return Listing(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      description: data['description'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // This converts to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'address': address,
      'phone': phone,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // This creates a new instance with updated values
  Listing copyWith({
    String? id,
    String? name,
    String? category,
    String? address,
    String? phone,
    String? description,
    double? latitude,
    double? longitude,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return Listing(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}