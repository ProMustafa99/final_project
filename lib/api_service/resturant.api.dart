import 'package:dio/dio.dart';
import 'package:final_project/config/app_config.dart';
import 'package:final_project/models/category.model.dart';
import 'package:final_project/models/resturant.model.dart';
import 'package:flutter/foundation.dart';

// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class ServiceApi {
  final Dio dio = Dio();

  // Cache for restaurants data
  List<ResturantModel>? _restaurantsCache;
  List<CategoryModel>? _categoriesCache;
  DateTime? _lastRestaurantsFetch;
  DateTime? _lastCategoriesFetch;

  // Cache duration (5 minutes)
  static const Duration _cacheDuration = Duration(minutes: 5);

  ServiceApi() {
    _setupDio();
  }

  void _setupDio() {
    // Add interceptors for logging and error handling
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('API Request: ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(
            'API Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('API Error: ${error.message}');
          handler.next(error);
        },
      ),
    );

    // Set default timeout
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  // Check if cache is valid
  bool _isCacheValid(DateTime? lastFetch) {
    if (lastFetch == null) return false;
    return DateTime.now().difference(lastFetch) < _cacheDuration;
  }

  // Clear cache (useful for testing or manual refresh)
  void clearCache() {
    _restaurantsCache = null;
    _categoriesCache = null;
    _lastRestaurantsFetch = null;
    _lastCategoriesFetch = null;
  }

  Future<List<ResturantModel>> getResturants({
    bool forceRefresh = false,
  }) async {
    // Return cached data if valid and not forcing refresh
    if (!forceRefresh &&
        _isCacheValid(_lastRestaurantsFetch) &&
        _restaurantsCache != null) {
      debugPrint('Returning cached restaurants data');
      return _restaurantsCache!;
    }

    try {
      final response = await dio.get(
        '${AppConfig.apiBaseUrlAndroid}/data.json',
        options: Options(responseType: ResponseType.json),
      );

      final List<dynamic> dataList = response.data as List<dynamic>;
      debugPrint('Fetched ${dataList.length} restaurants from API');

      // Parse and cache the data
      _restaurantsCache = dataList
          .map((json) => ResturantModel.fromJson(json as Map<String, dynamic>))
          .toList();
      _lastRestaurantsFetch = DateTime.now();

      return _restaurantsCache!;
    } on DioException catch (e) {
      final message = _getErrorMessage(e);
      debugPrint('Error fetching restaurants: $message');
      throw ApiException(message, e.response?.statusCode);
    } catch (e) {
      debugPrint('Unexpected error fetching restaurants: $e');
      throw ApiException('Unexpected error occurred');
    }
  }

  Future<ResturantModel?> getRestaurantDetails(int id) async {
    try {
      // Use cached data if available
      List<ResturantModel> restaurants;
      if (_isCacheValid(_lastRestaurantsFetch) && _restaurantsCache != null) {
        restaurants = _restaurantsCache!;
        debugPrint('Using cached data for restaurant details');
      } else {
        restaurants = await getResturants();
      }

      // Find the restaurant by ID
      final restaurant = restaurants.where((r) => r.id == id).firstOrNull;

      if (restaurant == null) {
        debugPrint('Restaurant with ID $id not found');
      }

      return restaurant;
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('Error fetching restaurant details: $e');
      throw ApiException('Failed to fetch restaurant details');
    }
  }

  Future<List<CategoryModel>> getCategories({bool forceRefresh = false}) async {
    // Return cached data if valid and not forcing refresh
    if (!forceRefresh &&
        _isCacheValid(_lastCategoriesFetch) &&
        _categoriesCache != null) {
      debugPrint('Returning cached categories data');
      return _categoriesCache!;
    }

    try {
      final response = await dio.get(
        '${AppConfig.apiBaseUrlAndroid}/categories.json',
        options: Options(responseType: ResponseType.json),
      );

      final List<dynamic> dataList = response.data as List<dynamic>;
      debugPrint('Fetched ${dataList.length} categories from API');

      // Parse and cache the data
      _categoriesCache = dataList
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
      _lastCategoriesFetch = DateTime.now();

      return _categoriesCache!;
    } on DioException catch (e) {
      final message = _getErrorMessage(e);
      debugPrint('Error fetching categories: $message');
      throw ApiException(message, e.response?.statusCode);
    } catch (e) {
      debugPrint('Unexpected error fetching categories: $e');
      throw ApiException('Unexpected error occurred');
    }
  }

  // Helper method to get meaningful error messages
  String _getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 404:
            return 'Resource not found.';
          case 500:
            return 'Server error. Please try again later.';
          default:
            return 'Network error (Status: $statusCode).';
        }
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      default:
        return 'Network error occurred.';
    }
  }
}
