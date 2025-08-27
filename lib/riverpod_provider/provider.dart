import 'package:final_project/api_service/resturant.api.dart';
import 'package:final_project/models/resturant.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainProvider extends AsyncNotifier<List<ResturantModel>> {
  @override
  Future<List<ResturantModel>> build() async {
    return [];
  }

  Future<void> fetchRestaurants() async {
    final fetchedRestaurants = await ResturantApi().getResturants();
    state = AsyncValue.data(fetchedRestaurants);
  }

  Future<void> getRestaurantDetails(int id) async {
    final fetchedRestaurantDetails = await ResturantApi().getRestaurantDetails(id);
    if (fetchedRestaurantDetails != null) {
      state = AsyncValue.data([fetchedRestaurantDetails]);
    } else {
      state = const AsyncValue.data([]);
    }
  }
}

final mainProvider = AsyncNotifierProvider<MainProvider, List<ResturantModel>>(MainProvider.new);