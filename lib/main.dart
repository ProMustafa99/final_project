import 'package:final_project/models/resturant.model.dart';
import 'package:final_project/pages/all_restaurants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
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
  //   final fetchedRestaurants = await ResturantApi().getResturants();
  //   setState(() {
  //     restaurants = fetchedRestaurants;
  //   });
  //   print("resturants Data: $restaurants");
  // }

  @override
  void initState() {
    super.initState();
    // _fetchResturants();
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

