class CategoryModel {
  final int id;
  final String name;
  final String icon;
  final String description;
  final String image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'image': image,
    };
  }
}