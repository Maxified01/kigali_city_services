import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kigali_city_services/models/listing.dart';
import 'package:kigali_city_services/providers/listings_provider.dart';
import 'package:kigali_city_services/screens/detail_screen.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
// remove this line
  
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    final listingsAsync = ref.watch(allListingsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Map View')),
      body: listingsAsync.when(
        data: (listings) {
          // Update markers when listings change
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateMarkers(listings);
          });
          return GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(-1.9441, 30.0619), // Kigali center
              zoom: 12,
            ),
            markers: _markers,
            onMapCreated: (controller) {
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _updateMarkers(List<Listing> listings) {
    final newMarkers = <Marker>{};
    for (var listing in listings) {
      newMarkers.add(
        Marker(
          markerId: MarkerId(listing.id),
          position: LatLng(listing.latitude, listing.longitude),
          infoWindow: InfoWindow(
            title: listing.name,
            snippet: listing.category,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(listingId: listing.id),
                ),
              );
            },
          ),
        ),
      );
    }
    setState(() {
      _markers.clear();
      _markers.addAll(newMarkers);
    });
  }
}