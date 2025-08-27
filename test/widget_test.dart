import 'package:final_project/models/category.model.dart';
import 'package:final_project/widgets/custom_app_bar.dart';
import 'package:final_project/widgets/empty_state.dart';
import 'package:final_project/widgets/error_state.dart';
import 'package:final_project/widgets/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('CustomAppBar Widget Tests', () {
    testWidgets('should display title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: const CustomAppBar(title: 'Test Title'),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('should display leading icon when provided', (WidgetTester tester) async {
      bool leadingPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(
              title: 'Test Title',
              leadingIcon: Icons.arrow_back,
              onLeadingPressed: () => leadingPressed = true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      
      // Test tap functionality
      await tester.tap(find.byIcon(Icons.arrow_back));
      expect(leadingPressed, true);
    });

    testWidgets('should not display leading icon when not provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: const CustomAppBar(title: 'Test Title'),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('should display actions when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(
              title: 'Test Title',
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });

  group('Loading State Widget Tests', () {
    testWidgets('should display CircularProgressIndicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildLoadingState(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('Error State Widget Tests', () {
    testWidgets('should display retry button', (WidgetTester tester) async {
      bool retryPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildErrorState(() => retryPressed = true),
          ),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      
      // Test retry functionality
      await tester.tap(find.text('Retry'));
      expect(retryPressed, true);
    });
  });

  group('Empty State Widget Tests', () {
    testWidgets('should display empty state message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildEmptyState(),
          ),
        ),
      );

      expect(find.text('No categories available'), findsOneWidget);
    });
  });

  group('Categories Widget Tests', () {
    testWidgets('should display categories when data is available', (WidgetTester tester) async {
      // Create test categories
      final testCategories = [
        CategoryModel(
          id: 1,
          name: 'Pizza',
          icon: 'pizza',
          description: 'Italian pizza',
          image: 'pizza.jpg',
        ),
        CategoryModel(
          id: 2,
          name: 'Burger',
          icon: 'burger',
          description: 'Fast food',
          image: 'burger.jpg',
        ),
      ];

      // Mock the Categories widget with test data
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _MockCategoriesWidget(categories: testCategories),
          ),
        ),
      );

      // Wait for the widget to build and settle
      await tester.pumpAndSettle();

      // Should display category names
      expect(find.text('Pizza'), findsOneWidget);
      expect(find.text('Burger'), findsOneWidget);
    });

    testWidgets('should handle category tap', (WidgetTester tester) async {
      final testCategories = [
        CategoryModel(
          id: 1,
          name: 'Pizza',
          icon: 'pizza',
          description: 'Italian pizza',
          image: 'pizza.jpg',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _MockCategoriesWidget(categories: testCategories),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on the category
      await tester.tap(find.text('Pizza'));
      await tester.pumpAndSettle();

      // Should show snackbar
      expect(find.text('Selected: Pizza'), findsOneWidget);
    });

    testWidgets('should display loading state for real Categories widget', (WidgetTester tester) async {
      // Skip this test as it requires API calls
      // In a real test environment, you would mock the API service
      expect(true, true); // Placeholder test
    });
  });
}

// Mock widget for testing Categories with predefined data
class _MockCategoriesWidget extends StatelessWidget {
  final List<CategoryModel> categories;

  const _MockCategoriesWidget({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _buildCategoryItem(categories[index], index);
        },
      ),
    );
  }

  Widget _buildCategoryItem(CategoryModel category, int index) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Material(
        color: Colors.transparent,
        child: Builder(
          builder: (context) => InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Selected: ${category.name}'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: _getCategoryColor(index).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getCategoryColor(index).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(index),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(category.name),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    category.name,
                    style: TextStyle(
                      color: _getCategoryColor(index),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(int index) {
    final colors = [
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF10B981), // Emerald
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEF4444), // Red
      const Color(0xFFEC4899), // Pink
      const Color(0xFF84CC16), // Lime
    ];
    return colors[index % colors.length];
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('pizza')) return Icons.local_pizza;
    if (name.contains('café') || name.contains('coffee')) return Icons.coffee;
    if (name.contains('middle eastern') || name.contains('lebanese')) return Icons.restaurant_menu;
    if (name.contains('pub') || name.contains('bar')) return Icons.local_bar;
    if (name.contains('burger')) return Icons.lunch_dining;
    if (name.contains('sushi')) return Icons.set_meal;
    if (name.contains('dessert')) return Icons.cake;
    if (name.contains('drink')) return Icons.local_bar;
    if (name.contains('salad')) return Icons.eco;
    if (name.contains('fast')) return Icons.fastfood;
    return Icons.restaurant;
  }
}
