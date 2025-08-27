import 'package:final_project/api_service/resturant.api.dart';
import 'package:final_project/models/resturant.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainProvider extends AsyncNotifier<List<ResturantModel>> {
  @override
  Future<List<ResturantModel>> build() async {
    return [];
  }

  Future<void> fetchRestaurants() async {
    final fetchedRestaurants = await ServiceApi().getResturants();
    state = AsyncValue.data(fetchedRestaurants);
  }
}

class RestaurantDetailsProvider extends AsyncNotifier<ResturantModel?> {
  @override
  Future<ResturantModel?> build() async {
    return null;
  }

  Future<void> getRestaurantDetails(int id) async {
    state = const AsyncValue.loading();
    final fetchedRestaurantDetails = await ServiceApi().getRestaurantDetails(
      id,
    );
    if (fetchedRestaurantDetails != null) {
      state = AsyncValue.data(fetchedRestaurantDetails);
    } else {
      state = const AsyncValue.data(null);
    }
  }
}

final mainProvider = AsyncNotifierProvider<MainProvider, List<ResturantModel>>(
  MainProvider.new,
);
final restaurantDetailsProvider =
    AsyncNotifierProvider<RestaurantDetailsProvider, ResturantModel?>(
      RestaurantDetailsProvider.new,
    );
