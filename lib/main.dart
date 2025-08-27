import 'package:final_project/config/app_config.dart';
import 'package:final_project/models/resturant.model.dart';
import 'package:final_project/pages/all_restaurants.dart';
import 'package:final_project/pages/restaurant_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load();
  runApp(const ProviderScope(child: MyApp()));
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<ResturantModel> restaurants = [];

  // void _fetchResturants() async {
  //   final fetchedRestaurant = await ResturantApi().getRestaurantDetails(1);
  //   if (fetchedRestaurant != null) {
  //     print("getRestaurantDetails Data: ${fetchedRestaurant.name} - ${fetchedRestaurant.address}");
  //   } else {
  //     print("Restaurant not found");
  //   }
  // }

  @override
  void initState() {
    super.initState();
  //  _fetchResturants();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AllRestaurants()
    );
  }
}

