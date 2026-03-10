import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kigali_city_services/providers/listings_provider.dart';
import 'package:kigali_city_services/screens/listing_form_screen.dart';
import 'package:kigali_city_services/widgets/listing_card.dart';

class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myListings = ref.watch(myListingsProvider);
    final allListingsAsync = ref.watch(allListingsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Listings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ListingFormScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: allListingsAsync.when(
        data: (_) {
          if (myListings.isEmpty) {
            return const Center(child: Text('You have no listings yet.'));
          }
          return ListView.builder(
            itemCount: myListings.length,
            itemBuilder: (context, index) {
              final listing = myListings[index];
              return ListingCard(
                listing: listing,
                isOwnListing: true, // enable edit/delete options
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}