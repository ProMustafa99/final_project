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
      height: 120, // a bit larger to prevent pixel overflow
      clipBehavior: Clip.none, // allow shadows to render outside
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade50,
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16), // ⬅ no vertical padding
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return _buildCategoryCard(categories[index], index);
      },
    );
  }

  Widget _buildCategoryCard(CategoryModel category, int index) {
    final colors = [
      [Colors.blue.shade400, Colors.blue.shade600],
      [Colors.purple.shade400, Colors.purple.shade600],
      [Colors.green.shade400, Colors.green.shade600],
      [Colors.orange.shade400, Colors.orange.shade600],
      [Colors.pink.shade400, Colors.pink.shade600],
      [Colors.indigo.shade400, Colors.indigo.shade600],
      [Colors.teal.shade400, Colors.teal.shade600],
      [Colors.amber.shade400, Colors.amber.shade600],
    ];

    final colorPair = colors[index % colors.length];

    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        shadowColor: colorPair[0].withOpacity(0.3),
        child: Container(
          width: 140,
          height: 90,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colorPair,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Selected: ${category.name}'),
                    backgroundColor: colorPair[0],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getCategoryIcon(category.name),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
