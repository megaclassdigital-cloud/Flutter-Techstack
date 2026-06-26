class SoftwareCategory {
  final String id;
  final String name;
  final String? description;
  final String? iconName;
  final String? colorHex;

  SoftwareCategory({
    required this.id,
    required this.name,
    this.description,
    this.iconName,
    this.colorHex,
  });

  factory SoftwareCategory.fromJson(Map<String, dynamic> json) =>
      SoftwareCategory(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        iconName: json['icon_name'],
        colorHex: json['color_hex'],
      );
}
