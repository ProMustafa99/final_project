import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? _mapController; // Make nullable
  LatLng? _currentPosition;
  Set<Marker> _markers = {};
  bool _isMapReady = false; // Add map ready flag
  bool _isLoading = true; // Add loading state
  String? _errorMessage; // Add error state

  void _onMapCreated(GoogleMapController controller) {
    print('✅ Google Maps: Map created successfully');
    _mapController = controller;
    _isMapReady = true;
    // Now that map is ready, get current location
    _getCurrentLocation();
  }

  @override
  void initState() {
    super.initState();
    print('🚀 Google Map Screen: Initializing...');
    // Don't call _getCurrentLocation here, wait for map to be ready
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;
    
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      print('📍 Getting current location...');
      
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      
      if (!serviceEnabled) {
        _showLocationDialog(
          'Location Services Disabled',
          'Please enable location services to use this feature.',
          'Enable Location',
          () => Geolocator.openLocationSettings(),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationDialog(
            'Location Permission Denied',
            'Location permission is required to show your current location.',
            'Grant Permission',
            () => Geolocator.openAppSettings(),
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _showLocationDialog(
          'Location Permission Permanently Denied',
          'Location permission has been permanently denied. Please enable it in app settings.',
          'Open Settings',
          () => Geolocator.openAppSettings(),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng current = LatLng(position.latitude, position.longitude);
      print('📍 Current location: $current');
      
      _setMarker(current);

      // Only animate camera if map controller is ready
      if (_mapController != null && _isMapReady) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(current, 15),
        );
      }

      setState(() {
        _isLoading = false;
      });
      
    } catch (e) {
      print('❌ Error getting current location: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to get location: $e';
      });
      
      // Show error dialog
      _showLocationDialog(
        'Location Error',
        'Failed to get your current location. Please try again.',
        'OK',
        () {},
      );
    }
  }

  /// 🔹 Show location permission/service dialog
  void _showLocationDialog(String title, String message, String actionText, VoidCallback onAction) {
    if (!mounted) return; // Check if widget is still mounted
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onAction();
              },
              child: Text(actionText),
            ),
          ],
        );
      },
    );
  }

  /// 🔹 Centralized function to add/update marker
  void _setMarker(LatLng position) {
    if (!mounted) return; // Check if widget is still mounted
    
    setState(() {
      _currentPosition = position;
      _markers = {
        Marker(
          markerId: const MarkerId("current_location"),
          position: position,
          infoWindow: InfoWindow(
            title: "Current Location",
            snippet: "Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          draggable: true,
          onDragEnd: (LatLng newPosition) {
            _setMarker(newPosition);
          },
        ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          if (_isMapReady)
            IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: _getCurrentLocation,
              tooltip: 'Get Current Location',
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(-23.5557714, -46.6395571), // São Paulo, Brazil
              zoom: 12.0,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
            onCameraMove: (CameraPosition position) {
              print('📍 Camera moved to: ${position.target}');
            },
          ),
          
          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Getting your location...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
          // Error overlay
          if (_errorMessage != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade800),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
