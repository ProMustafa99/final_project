import 'package:final_project/config/app_config.dart';
import 'package:dio/dio.dart';
import 'package:final_project/models/resturant.model.dart';

class ResturantApi {
  final Dio dio = Dio();

  Future<List<ResturantModel>> getResturants() async {
    final response = await dio.get(AppConfig.apiDataEndpoint);
    return response.data['data'].map((json) => ResturantModel.fromJson(json)).toList();
  }
}
