class Vendor {
  final String id;
  final String name;
  final String? websiteUrl;
  final String? country;
  final String? description;

  Vendor({
    required this.id,
    required this.name,
    this.websiteUrl,
    this.country,
    this.description,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
    id: json['id'],
    name: json['name'],
    websiteUrl: json['website_url'],
    country: json['country'],
    description: json['description'],
  );
}
