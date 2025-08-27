import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:final_project/riverpod_provider/provider.dart';
import 'package:go_router/go_router.dart';

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
      appBar: AppBar(title: const Text('Home')),
      body: restaurantsAsync.when(
        data: (restaurants) {
          if (restaurants.isEmpty) {
            return const Center(child: Text('No restaurants found'));
          }
          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(restaurants[index].name),
                subtitle: Text(restaurants[index].address),
                onTap: () {
                  debugPrint("restaurant: ${restaurants[index].name}");
                  context.go('/restaurant/${restaurants[index].id}');
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
