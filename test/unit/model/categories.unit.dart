import 'package:final_project/models/category.model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategoryModel', () {
    test('should correctly parse from JSON', () {
      final json = {
        'id': 1,
        'name': 'Italian',
        'icon': '🍝',
        'description': 'Italian cuisine',
        'image': 'https://example.com/italian.jpg'
      };

      final category = CategoryModel.fromJson(json);

      expect(category.id, 1);
      expect(category.name, 'Italian');
      expect(category.icon, '🍝');
      expect(category.description, 'Italian cuisine');
      expect(category.image, 'https://example.com/italian.jpg');
    });

    test('should convert to JSON correctly', () {
      final category = CategoryModel(
        id: 2,
        name: 'Pizza',
        icon: '🍕',
        description: 'Pizza restaurants',
        image: 'https://example.com/pizza.jpg',
      );

      final json = category.toJson();

      expect(json['id'], 2);
      expect(json['name'], 'Pizza');
      expect(json['icon'], '🍕');
      expect(json['description'], 'Pizza restaurants');
      expect(json['image'], 'https://example.com/pizza.jpg');
    });

    test('should handle empty strings in JSON', () {
      final json = {
        'id': 3,
        'name': '',
        'icon': '',
        'description': '',
        'image': ''
      };

      final category = CategoryModel.fromJson(json);

      expect(category.id, 3);
      expect(category.name, '');
      expect(category.icon, '');
      expect(category.description, '');
      expect(category.image, '');
    });
  });
}
