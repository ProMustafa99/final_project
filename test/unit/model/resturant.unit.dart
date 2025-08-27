import 'package:flutter_test/flutter_test.dart';
import 'package:final_project/models/resturant.model.dart';

void main() {
  group('ResturantModel', () {
    test('should correctly parse from JSON', () {
      final json = {
        'id': 1,
        'name': 'Pizza Place',
        'address': '123 Main St',
        'location': {'lat': 40.7128, 'lng': -74.0060},
        'rate': 4.5,
        'category': 'Italian',
        'image': 'https://example.com/pizza.jpg'
      };

      final restaurant = ResturantModel.fromJson(json);

      expect(restaurant.id, 1);
      expect(restaurant.name, 'Pizza Place');
      expect(restaurant.address, '123 Main St');
      expect(restaurant.location['lat'], 40.7128);
      expect(restaurant.rate, 4.5);
      expect(restaurant.category, 'Italian');
      expect(restaurant.image, isNotNull);
    });

    test('should handle int rate by converting to double', () {
      final json = {
        'id': 2,
        'name': 'Burger Shop',
        'address': '456 Side St',
        'location': {'lat': 41.0, 'lng': -75.0},
        'rate': 5, // int instead of double
        'category': 'Fast Food',
        'image': null,  
      };

      final restaurant = ResturantModel.fromJson(json);

      expect(restaurant.rate, 5.0); // should convert to double
    });
  });
}
