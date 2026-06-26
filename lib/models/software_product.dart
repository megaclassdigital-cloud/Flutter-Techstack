class SoftwareProduct {
  final String id;
  final String name;
  final String? shortDescription;
  final String? description;
  final String? platform;
  final String? version;
  final String? pricingType;
  final String? websiteUrl;
  final String? mainImageUrl;
  final double rating;
  final bool isFeatured;
  final String? categoryId;
  final String? vendorId;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined fields
  final String? categoryName;
  final String? categoryIcon;
  final String? categoryColor;
  final String? vendorName;
  final String? vendorWebsite;
  final String? creatorName;

  SoftwareProduct({
    required this.id,
    required this.name,
    this.shortDescription,
    this.description,
    this.platform,
    this.version,
    this.pricingType,
    this.websiteUrl,
    this.mainImageUrl,
    required this.rating,
    required this.isFeatured,
    this.categoryId,
    this.vendorId,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.categoryName,
    this.categoryIcon,
    this.categoryColor,
    this.vendorName,
    this.vendorWebsite,
    this.creatorName,
  });

  factory SoftwareProduct.fromJson(Map<String, dynamic> json) {
    // Parse nested join objects
    final categoryJson = json['software_categories'];
    final vendorJson = json['vendors'];
    final creatorJson = json['profiles'];

    return SoftwareProduct(
      id: json['id'],
      name: json['name'],
      shortDescription: json['short_description'],
      description: json['description'],
      platform: json['platform'],
      version: json['version'],
      pricingType: json['pricing_type'],
      websiteUrl: json['website_url'],
      mainImageUrl: json['main_image_url'],
      rating: (json['rating'] ?? 0).toDouble(),
      isFeatured: json['is_featured'] ?? false,
      categoryId: json['category_id'],
      vendorId: json['vendor_id'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      categoryName: categoryJson?['name'],
      categoryIcon: categoryJson?['icon_name'],
      categoryColor: categoryJson?['color_hex'],
      vendorName: vendorJson?['name'],
      vendorWebsite: vendorJson?['website_url'],
      creatorName: creatorJson?['full_name'],
    );
  }
}
