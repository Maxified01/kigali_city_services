import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kigali_city_services/models/listing.dart';
import 'package:kigali_city_services/services/firestore_service.dart';
import 'package:kigali_city_services/providers/auth_provider.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Stream of all listings
final allListingsStreamProvider = StreamProvider<List<Listing>>((ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.getListingsStream();
});

// Search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final categoriesProvider = Provider<List<String>>((ref) {
  return [
    'Hospital',
    'Police Station',
    'Library',
    'Restaurant',
    'Café',
    'Park',
    'Tourist Attraction',
    'Mall',
    'Government Facility',
  ];
});

// Filtered listings based on search query and category
final filteredListingsProvider = Provider<List<Listing>>((ref) {
  final listingsAsync = ref.watch(allListingsStreamProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final category = ref.watch(selectedCategoryProvider);

  return listingsAsync.maybeWhen(
    data: (listings) {
      return listings.where((listing) {
        final matchesQuery = listing.name.toLowerCase().contains(query);
        final matchesCategory = category == null || listing.category == category;
        return matchesQuery && matchesCategory;
      }).toList();
    },
    orElse: () => [],
  );
});

// My listings (filtered by current user)
final myListingsProvider = Provider<List<Listing>>((ref) {
  final listingsAsync = ref.watch(allListingsStreamProvider);
  final user = ref.watch(authStateProvider).value;

  return listingsAsync.maybeWhen(
    data: (listings) {
      if (user == null) return [];
      return listings.where((listing) => listing.createdBy == user.uid).toList();
    },
    orElse: () => [],
  );
});