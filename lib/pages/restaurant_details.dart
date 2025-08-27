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

  Widget _buildChip({required IconData icon, required String label, Color? color, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (color ?? Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor ?? Colors.grey.shade800),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor ?? Colors.grey.shade800),
          ),
        ],
      ),
    );
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
                // Hero image card
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 220,
                        child: restaurant.image != null
                            ? Image.network(
                                restaurant.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: Icon(Icons.restaurant, size: 56, color: Colors.grey[500]),
                                  );
                                },
                              )
                            : Container(
                                color: Colors.grey[200],
                                child: Icon(Icons.restaurant, size: 56, color: Colors.grey[500]),
                              ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.45),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  restaurant.name,
                                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildChip(
                                icon: Icons.star,
                                label: restaurant.rate.toStringAsFixed(1),
                                color: Colors.amber.shade100,
                                textColor: Colors.amber.shade900,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Info row chips
                Row(
                  children: [
                    _buildChip(
                      icon: Icons.location_on,
                      label: restaurant.address,
                      color: Colors.red.shade50,
                      textColor: Colors.red.shade700,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    _buildChip(
                      icon: Icons.category,
                      label: restaurant.category,
                      color: Colors.blue.shade50,
                      textColor: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    _buildChip(
                      icon: Icons.verified,
                      label: 'Rating ${restaurant.rate.toStringAsFixed(1)}',
                      color: Colors.green.shade50,
                      textColor: Colors.green.shade700,
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // Map Section
                Row(
                  children: const [
                    Icon(Icons.map, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      'Location',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 1.5,
                  clipBehavior: Clip.antiAlias,
                  child: RestaurantMap(
                    restaurant: restaurant,
                    height: 280,
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                  color: Colors.grey.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.my_location, color: Colors.grey.shade700),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Coordinates: ${restaurant.location['lat']?.toStringAsFixed(6)}, ${restaurant.location['lng']?.toStringAsFixed(6)}",
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Copy'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Quick actions (placeholder - no external deps)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.phone_outlined),
                        label: const Text('Call'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share_outlined),
                        label: const Text('Share'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
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