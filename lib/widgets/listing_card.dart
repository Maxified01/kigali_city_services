import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kigali_city_services/models/listing.dart';
import 'package:kigali_city_services/providers/listings_provider.dart';
import 'package:kigali_city_services/screens/detail_screen.dart';
import 'package:kigali_city_services/screens/listing_form_screen.dart';

class ListingCard extends ConsumerWidget {
  final Listing listing;
  final bool isOwnListing; // if true, show edit/delete buttons

  const ListingCard({super.key, required this.listing, this.isOwnListing = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestore = ref.read(firestoreServiceProvider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(listing.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(listing.category),
            Text('${listing.address} • ${listing.phone}'),
          ],
        ),
        trailing: isOwnListing
            ? PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListingFormScreen(listing: listing),
                      ),
                    );
                  } else if (value == 'delete') {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete Listing'),
                        content: Text('Delete "${listing.name}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await firestore.deleteListing(listing.id);
                    }
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              )
            : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailScreen(listingId: listing.id),
            ),
          );
        },
      ),
    );
  }
}