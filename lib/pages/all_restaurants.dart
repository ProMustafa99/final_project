import 'package:final_project/widgets/categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:final_project/riverpod_provider/provider.dart';
import 'package:final_project/models/resturant.model.dart';
import 'package:go_router/go_router.dart';
import 'package:final_project/widgets/loading_state.dart';
import 'package:final_project/widgets/error_state.dart';
import 'package:final_project/widgets/custom_app_bar.dart';

class AllRestaurants extends ConsumerStatefulWidget {
  const AllRestaurants({super.key});

  @override
  ConsumerState<AllRestaurants> createState() => _AllRestaurantsState();
}

class _AllRestaurantsState extends ConsumerState<AllRestaurants> {
  @override
  void initState() {
    super.initState();
    ref.read(mainProvider.notifier).fetchRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantsAsync = ref.watch(mainProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'All Restaurants',
        leadingIcon: Icons.person,
        onLeadingPressed: () {
          // Handle profile button
        },
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.grey.shade700,
            ),
            onPressed: () {
              // Handle search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Categories(),
          Expanded(
            child: restaurantsAsync.when(
              data: (restaurants) {
                if (restaurants.isEmpty) {
                  return const Center(child: Text('No restaurants found'));
                }
                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 12,
                  padding: const EdgeInsets.all(10),
                  childAspectRatio: 0.85,
                  children: List.generate(restaurants.length, (index) {
                    return _buildRestaurantCard(restaurants[index], index);
                  }),
                );
              },
              loading: () => buildLoadingState(),
              error: (error, stack) => buildErrorState(() {
                ref.read(mainProvider.notifier).fetchRestaurants();
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(ResturantModel restaurant, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.go('/restaurant/${restaurant.id}');
        },
        child: Column(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: restaurant.image != null && restaurant.image!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        restaurant.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.restaurant,
                              size: 40,
                              color: Colors.grey.shade500,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 40,
                        color: Colors.grey.shade500,
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.address,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.rate.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          restaurant.category,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
