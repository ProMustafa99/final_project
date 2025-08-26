class ResturantModel {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String website;

  ResturantModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.website,
  });

  factory ResturantModel.fromJson(Map<String, dynamic> json) {
    return ResturantModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      website: json['website'],
    );
  }
}