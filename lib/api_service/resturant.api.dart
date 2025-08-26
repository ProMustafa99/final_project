import 'package:dio/dio.dart';
import 'package:final_project/models/resturant.model.dart';

class ResturantApi {
  final Dio dio = Dio();

  Future<List<ResturantModel>> getResturants() async {
    try {
      final response = await dio.get(
        "http://10.0.2.2:3000/assets/data.json",
        options: Options(responseType: ResponseType.json),
      );      
      final List<dynamic> dataList = response.data as List<dynamic>;
      return dataList
          .map((json) => ResturantModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching restaurants: $e');
      return [];
    }
  }
}
