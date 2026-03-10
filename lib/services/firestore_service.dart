import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kigali_city_services/models/listing.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of all listings (real-time)
  Stream<List<Listing>> getListingsStream() {
    return _firestore
        .collection('listings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Listing.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }

  // Add a new listing
  Future<void> addListing(Listing listing) async {
    await _firestore.collection('listings').add(listing.toMap());
  }

  // Update an existing listing
  Future<void> updateListing(Listing listing) async {
    await _firestore
        .collection('listings')
        .doc(listing.id)
        .update(listing.toMap());
  }

  // Delete a listing
  Future<void> deleteListing(String listingId) async {
    await _firestore.collection('listings').doc(listingId).delete();
  }

  // Get a single listing by ID (for detail view)
  Future<Listing?> getListingById(String id) async {
    final doc = await _firestore.collection('listings').doc(id).get();
    if (doc.exists) {
      return Listing.fromFirestore(doc.id, doc.data()!);
    }
    return null;
  }
}