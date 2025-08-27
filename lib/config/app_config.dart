import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
  static String get apiDataEndpoint => dotenv.env['API_DATA_ENDPOINT'] ?? 'http://localhost:3000/assets/data.json';
  
  // Platform-specific URLs
  static String get apiBaseUrlAndroid => dotenv.env['API_BASE_URL_ANDROID'] ?? 'http://10.0.2.2:3000/assets';
  static String get apiDataEndpointAndroid => dotenv.env['API_DATA_ENDPOINT_ANDROID'] ?? 'http://10.0.2.2:3000/assets/data.json';
  
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }
}
