import 'package:dio/dio.dart';
import '../config/app_config.dart';

class Restaurant {
  final int id;
  final String name;
  final Map<String, double> location;
  final double rate;
  final String category;
  final String address;

  Restaurant({
    required this.id,
    required this.name,
    required this.location,
    required this.rate,
    required this.category,
    required this.address,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      location: Map<String, double>.from(json['location']),
      rate: json['rate'].toDouble(),
      category: json['category'],
      address: json['address'],
    );
  }
}

class RestaurantService {
  final Dio _dio = Dio();

  Future<List<Restaurant>> getRestaurants() async {
    try {
      final response = await _dio.get(AppConfig.apiDataEndpoint);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Restaurant.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load restaurants');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
