import 'package:dio/dio.dart';
import 'package:final_project/api_service/service.api.dart';
import 'package:final_project/models/resturant.model.dart';
import 'package:final_project/models/category.model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'service_api_test.mocks.dart';

// Generate nice mocks so that accessing properties like interceptors won't throw
@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late MockDio mockDio;
  late ServiceApi serviceApi;

  setUp(() {
    mockDio = MockDio();
    serviceApi = ServiceApi(dio: mockDio); // inject mocked Dio
  });

  group('ServiceApi - Restaurants', () {
    test('should fetch and parse restaurants', () async {
      // Arrange: mocked API response
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/data.json'),
        data: [
          {
            'id': 1,
            'name': 'Pizza Place',
            'address': '123 Main St',
            'location': {'lat': 40.7128, 'lng': -74.0060},
            'rate': 4.5,
            'category': 'Italian',
            'image': 'pizza.jpg',
          },
        ],
        statusCode: 200,
      );

      when(
        mockDio.get(argThat(contains('data.json')), options: anyNamed('options')),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await serviceApi.getResturants(forceRefresh: true);

      // Assert
      expect(result, isA<List<ResturantModel>>());
      expect(result.length, 1);
      expect(result.first.name, 'Pizza Place');
      expect(result.first.rate, 4.5);
    });

    test('should throw ApiException on Dio error', () async {
      // Arrange: mocked Dio throws connection timeout
      when(mockDio.get(argThat(contains('data.json')), options: anyNamed('options'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/data.json'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      // Act & Assert
      expect(
        () async => await serviceApi.getResturants(forceRefresh: true),
        throwsA(isA<ApiException>()),
      );
    });

    test(
      'should return cached data if available and not forcing refresh',
      () async {
        // Arrange: first call returns mocked data
        final mockResponse = Response(
          requestOptions: RequestOptions(path: '/data.json'),
          data: [
            {
              'id': 2,
              'name': 'Burger Place',
              'address': '456 Side St',
              'location': {'lat': 41.0, 'lng': -75.0},
              'rate': 5.0,
              'category': 'Fast Food',
              'image': 'burger.jpg',
            },
          ],
          statusCode: 200,
        );

        when(
          mockDio.get(argThat(contains('data.json')), options: anyNamed('options')),
        ).thenAnswer((_) async => mockResponse);

        // Act: first call fetches from API
        final firstCall = await serviceApi.getResturants(forceRefresh: true);

        // Act: second call uses cache
        final secondCall = await serviceApi.getResturants();

        // Assert
        expect(secondCall, firstCall); // same cached instance
        verify(
          mockDio.get(argThat(contains('data.json')), options: anyNamed('options')),
        ).called(1); // API called only once
      },
    );

    test('should handle empty restaurant list', () async {
      // Arrange: mocked API returns empty list
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/data.json'),
        data: [],
        statusCode: 200,
      );

      when(
        mockDio.get(argThat(contains('data.json')), options: anyNamed('options')),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await serviceApi.getResturants(forceRefresh: true);

      // Assert
      expect(result, isEmpty);
    });

    test('should handle malformed JSON data', () async {
      // Arrange: mocked API returns malformed data
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/data.json'),
        data: [
          {
            'id': 'invalid_id', // should be int
            'name': 'Pizza Place',
            // missing required fields
          },
        ],
        statusCode: 200,
      );

      when(
        mockDio.get(argThat(contains('data.json')), options: anyNamed('options')),
      ).thenAnswer((_) async => mockResponse);

      // Act & Assert
      expect(
        () async => await serviceApi.getResturants(forceRefresh: true),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('ServiceApi - Categories', () {
    test('should fetch and parse categories', () async {
      // Arrange: mocked API response
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/categories.json'),
        data: [
          {
            'id': 1,
            'name': 'Italian',
            'icon': '🍝',
            'description': 'Italian cuisine',
            'image': 'italian.jpg',
          },
        ],
        statusCode: 200,
      );

      when(
        mockDio.get(argThat(contains('categories.json')), options: anyNamed('options')),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await serviceApi.getCategories(forceRefresh: true);

      // Assert
      expect(result, isA<List<CategoryModel>>());
      expect(result.length, 1);
      expect(result.first.name, 'Italian');
      expect(result.first.icon, '🍝');
    });

    test('should return cached categories if available', () async {
      // Arrange: first call returns mocked data
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/categories.json'),
        data: [
          {
            'id': 2,
            'name': 'Pizza',
            'icon': '🍕',
            'description': 'Pizza restaurants',
            'image': 'pizza.jpg',
          },
        ],
        statusCode: 200,
      );

      when(
        mockDio.get(argThat(contains('categories.json')), options: anyNamed('options')),
      ).thenAnswer((_) async => mockResponse);

      // Act: first call fetches from API
      final firstCall = await serviceApi.getCategories(forceRefresh: true);

      // Act: second call uses cache
      final secondCall = await serviceApi.getCategories();

      // Assert
      expect(secondCall, firstCall); // same cached instance
      verify(
        mockDio.get(argThat(contains('categories.json')), options: anyNamed('options')),
      ).called(1); // API called only once
    });
  });

  group('ServiceApi - Restaurant Details', () {
    test('should get restaurant details by ID', () async {
      // Arrange: setup restaurants cache first
      final mockRestaurantsResponse = Response(
        requestOptions: RequestOptions(path: '/data.json'),
        data: [
          {
            'id': 1,
            'name': 'Pizza Place',
            'address': '123 Main St',
            'location': {'lat': 40.7128, 'lng': -74.0060},
            'rate': 4.5,
            'category': 'Italian',
            'image': 'pizza.jpg',
          },
          {
            'id': 2,
            'name': 'Burger Place',
            'address': '456 Side St',
            'location': {'lat': 41.0, 'lng': -75.0},
            'rate': 5.0,
            'category': 'Fast Food',
            'image': 'burger.jpg',
          },
        ],
        statusCode: 200,
      );

      when(
        mockDio.get(argThat(contains('data.json')), options: anyNamed('options')),
      ).thenAnswer((_) async => mockRestaurantsResponse);

      // Act: fetch restaurants first
      await serviceApi.getResturants(forceRefresh: true);

      // Act: get restaurant details
      final result = await serviceApi.getRestaurantDetails(1);

      // Assert
      expect(result, isNotNull);
      expect(result!.name, 'Pizza Place');
      expect(result.id, 1);
    });

    test('should return null for non-existent restaurant ID', () async {
      // Arrange: setup restaurants cache first
      final mockRestaurantsResponse = Response(
        requestOptions: RequestOptions(path: '/data.json'),
        data: [
          {
            'id': 1,
            'name': 'Pizza Place',
            'address': '123 Main St',
            'location': {'lat': 40.7128, 'lng': -74.0060},
            'rate': 4.5,
            'category': 'Italian',
            'image': 'pizza.jpg',
          },
        ],
        statusCode: 200,
      );

      when(
        mockDio.get(argThat(contains('data.json')), options: anyNamed('options')),
      ).thenAnswer((_) async => mockRestaurantsResponse);

      // Act: fetch restaurants first
      await serviceApi.getResturants(forceRefresh: true);

      // Act: get restaurant details for non-existent ID
      final result = await serviceApi.getRestaurantDetails(999);

      // Assert
      expect(result, isNull);
    });
  });

  group('ServiceApi - Cache Management', () {
    test('should clear cache when clearCache is called', () async {
      // Arrange: setup some cached data
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/data.json'),
        data: [
          {
            'id': 1,
            'name': 'Pizza Place',
            'address': '123 Main St',
            'location': {'lat': 40.7128, 'lng': -74.0060},
            'rate': 4.5,
            'category': 'Italian',
            'image': 'pizza.jpg',
          },
        ],
        statusCode: 200,
      );

      when(
        mockDio.get(argThat(contains('data.json')), options: anyNamed('options')),
      ).thenAnswer((_) async => mockResponse);

      // Act: fetch data to populate cache
      await serviceApi.getResturants(forceRefresh: true);

      // Act: clear cache
      serviceApi.clearCache();

      // Act: fetch again (should hit API again)
      await serviceApi.getResturants(forceRefresh: true);

      // Assert: API should be called twice
      verify(
        mockDio.get(argThat(contains('data.json')), options: anyNamed('options')),
      ).called(2);
    });
  });
}
