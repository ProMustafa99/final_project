import 'package:flutter/material.dart';
import 'package:final_project/models/category.model.dart';
import 'package:final_project/api_service/service.api.dart';
import 'package:final_project/widgets/loading_state.dart';
import 'package:final_project/widgets/error_state.dart';
import 'package:final_project/widgets/empty_state.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<CategoryModel> categories = [];
  final ServiceApi _serviceApi = ServiceApi();
  bool _isLoading = true;
  String? _error;

  Future<void> _fetchCategories() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final fetchedCategories = await _serviceApi.getCategories();
      setState(() {
        categories = fetchedCategories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

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
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) return buildLoadingState();
    if (_error != null) return buildErrorState(_fetchCategories);
    if (categories.isEmpty) return buildEmptyState();
    return _buildCategoriesList();
  }

  Widget _buildCategoriesList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return _buildCategoryItem(categories[index], index);
      },
    );
  }

  Widget _buildCategoryItem(CategoryModel category, int index) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
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
