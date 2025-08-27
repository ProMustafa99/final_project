import 'package:final_project/riverpod_provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:final_project/widgets/custom_app_bar.dart';
import 'package:final_project/google_map /restaurant_map.dart';

class RestaurantDetails extends ConsumerStatefulWidget {
  final int restaurantId;
  
  const RestaurantDetails({super.key, required this.restaurantId});

  @override
  ConsumerState<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends ConsumerState<RestaurantDetails> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(restaurantDetailsProvider.notifier).getRestaurantDetails(widget.restaurantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final restaurantDetails = ref.watch(restaurantDetailsProvider);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Restaurant Details',
        leadingIcon: Icons.arrow_back,
        onLeadingPressed: () => context.go('/'),
      ),
      body: restaurantDetails.when(
        data: (restaurant) {
          if (restaurant == null) {
            return const Center(child: Text('Restaurant not found'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: restaurant.image != null
                      ? Image.network(
                          restaurant.image!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey[300],
                              child: Icon(Icons.restaurant, size: 50, color: Colors.grey[600]),
                            );
                          },
                        )
                      : Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[300],
                          child: Icon(Icons.restaurant, size: 50, color: Colors.grey[600]),
                        ),
                ),
                const SizedBox(height: 16),
                
                // Restaurant Name
                Text(
                  restaurant.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                
                // Restaurant Address
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        restaurant.address,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Restaurant Category
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    restaurant.category,
                    style: TextStyle(fontSize: 14, color: Colors.blue.shade700, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Restaurant Rating
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${restaurant.rate}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Rating',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Map Section
                const Text(
                  'Location',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                // Restaurant Map
                RestaurantMap(
                  restaurant: restaurant,
                  height: 300,
                ),
                
                const SizedBox(height: 16),
                
                // Coordinates info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                                                 child: Text(
                           "Coordinates: ${restaurant.location['lat']?.toStringAsFixed(6)}, ${restaurant.location['lng']?.toStringAsFixed(6)}",
                           style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                         ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}