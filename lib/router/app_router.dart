import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:final_project/pages/all_restaurants.dart';
import 'package:final_project/pages/restaurant_details.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const AllRestaurants(),
    ),
    GoRoute(
      path: '/restaurant/:id',
      name: 'restaurant_details',
      builder: (context, state) {
        final restaurantId = int.tryParse(state.pathParameters['id'] ?? '');
        if (restaurantId == null) {
          return const Scaffold(
            body: Center(child: Text('Invalid restaurant ID')),
          );
        }
        return RestaurantDetails(restaurantId: restaurantId);
      },
    ),
  ],
);
