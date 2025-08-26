class ResturantModel {
  final int id;
  final String name;
  final String address;
  final Map<String, double> location;
  final double rate;
  final String category;

  ResturantModel({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.rate,
    required this.category,
  });

  factory ResturantModel.fromJson(Map<String, dynamic> json) {
    return ResturantModel(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      location: Map<String, double>.from(json['location']),
      rate: (json['rate'] is int) ? (json['rate'] as int).toDouble() : json['rate'] as double,
      category: json['category'] as String,
    );
  }
}