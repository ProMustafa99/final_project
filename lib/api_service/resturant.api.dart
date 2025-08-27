import 'package:dio/dio.dart';
import 'package:final_project/config/app_config.dart';
import 'package:final_project/models/resturant.model.dart';
import 'package:flutter/foundation.dart';

class ResturantApi {
  final Dio dio = Dio();

  Future<List<ResturantModel>> getResturants() async {
    try {
      final response = await dio.get(
        AppConfig.apiDataEndpointAndroid,
        options: Options(responseType: ResponseType.json),
      );      
      final List<dynamic> dataList = response.data as List<dynamic>;
      debugPrint('Restaurants data: $dataList');
      return dataList
          .map((json) => ResturantModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching restaurants: $e');
      return [];
    }
  }

  Future<ResturantModel?> getRestaurantDetails(int id) async {
    try {
      final response = await dio.get(
        AppConfig.apiDataEndpointAndroid,
        options: Options(responseType: ResponseType.json),
      );

      final List<dynamic> dataList = response.data as List<dynamic>;

      for(var data in dataList) {
        if(data['id'] == id) {
          return ResturantModel.fromJson(data as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching restaurant details: $e');
      return null;
    }
  }
}
