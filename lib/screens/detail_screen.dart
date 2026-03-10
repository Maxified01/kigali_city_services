import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kigali_city_services/models/listing.dart';
import 'package:kigali_city_services/providers/listings_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final String listingId;
  const DetailScreen({super.key, required this.listingId});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  late Future<Listing?> _listingFuture;

  @override
  void initState() {
    super.initState();
    _listingFuture = ref.read(firestoreServiceProvider).getListingById(widget.listingId);
  }

  Future<void> _openDirections(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listing Details')),
      body: FutureBuilder<Listing?>(
        future: _listingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final listing = snapshot.data;
          if (listing == null) {
            return const Center(child: Text('Listing not found'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listing.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Chip(label: Text(listing.category)),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(listing.address),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(listing.phone),
                ),
                if (listing.description.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: Text(listing.description),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 250,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(listing.latitude, listing.longitude),
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(listing.id),
                        position: LatLng(listing.latitude, listing.longitude),
                      ),
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.directions),
                    label: const Text('Get Directions'),
                    onPressed: () => _openDirections(listing.latitude, listing.longitude),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}