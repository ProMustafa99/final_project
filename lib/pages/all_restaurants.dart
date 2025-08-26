import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:final_project/riverpod_provider/provider.dart';

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
      appBar: AppBar(title: Text('Restaurants')),
      body: ListView.builder(
        itemCount: restaurantsAsync.valueOrNull?.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(restaurantsAsync.valueOrNull?[index].name ?? ''),
          );
        },
      ),
    );
  }
}
