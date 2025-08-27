import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:final_project/models/resturant.model.dart';

class RestaurantMap extends StatefulWidget {
  final ResturantModel restaurant;
  final double height;
  
  const RestaurantMap({
    super.key, 
    required this.restaurant, 
    this.height = 300,
  });

  @override
  State<RestaurantMap> createState() => _RestaurantMapState();
}

class _RestaurantMapState extends State<RestaurantMap> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _createRestaurantMarker();
  }

  void _createRestaurantMarker() {
    final restaurant = widget.restaurant;
    final lat = restaurant.location['lat'] ?? 0.0;
    final lng = restaurant.location['lng'] ?? 0.0;
    
    if (lat != 0.0 && lng != 0.0) {
      _markers = {
        Marker(
          markerId: MarkerId('restaurant_${restaurant.id}'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: restaurant.name,
            snippet: restaurant.address,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () {
            _showRestaurantInfo();
          },
        ),
      };
    }
  }

  void _showRestaurantInfo() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.restaurant, color: Colors.red.shade600, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.restaurant.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.restaurant.address,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${widget.restaurant.rate}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.restaurant.category,
                    style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _centerOnRestaurant();
                    },
                    icon: const Icon(Icons.center_focus_strong),
                    label: const Text('Center on Restaurant'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _centerOnRestaurant() {
    if (_mapController == null) return;
    
    final restaurant = widget.restaurant;
    final lat = restaurant.location['lat'] ?? 0.0;
    final lng = restaurant.location['lng'] ?? 0.0;
    
    if (lat != 0.0 && lng != 0.0) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(lat, lng),
          16.0,
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    print('✅ Restaurant Map: Map created successfully');
    _mapController = controller;
    _isMapReady = true;
    
    // Automatically center on restaurant location
    _centerOnRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurant;
    final lat = restaurant.location['lat'] ?? 0.0;
    final lng = restaurant.location['lng'] ?? 0.0;
    
    // Use restaurant location as initial position, or fallback
    final initialPosition = (lat != 0.0 && lng != 0.0) 
        ? LatLng(lat, lng) 
        : const LatLng(-23.5557714, -46.6395571); // São Paulo fallback

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 15.0,
              ),
              markers: _markers,
              zoomControlsEnabled: true,
              mapType: MapType.normal,
              myLocationEnabled: false, // Disable user location
              myLocationButtonEnabled: false,
              onCameraMove: (CameraPosition position) {
                print('📍 Restaurant map camera moved to: ${position.target}');
              },
            ),
            
            // Restaurant info overlay
            if (_isMapReady)
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.red.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              restaurant.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        restaurant.address,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Center restaurant button
            if (_isMapReady)
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton.small(
                  onPressed: _centerOnRestaurant,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red.shade600,
                  child: const Icon(Icons.center_focus_strong),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
