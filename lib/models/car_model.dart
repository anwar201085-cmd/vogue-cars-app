class Car {
  final String id;
  final String title;
  final String brand;
  final String model;
  final int year;
  final double price;
  final List<String> images;
  final bool isActive;
  final String condition; // 'New', 'Used', 'Electric'
  final bool hasElectricWarranty;

  Car({
    required this.id,
    required this.title,
    required this.brand,
    required this.model,
    required this.year,
    required this.price,
    required this.images,
    required this.condition,
    this.hasElectricWarranty = false,
    this.isActive = true,
  });

  factory Car.fromFirestore(Map<String, dynamic> data, String id) {
    return Car(
      id: id,
      title: data['title'] ?? '',
      brand: data['brand'] ?? '',
      model: data['model'] ?? '',
      year: data['year'] ?? 0,
      price: (data['price'] ?? 0).toDouble(),
      images: List<String>.from(data['images'] ?? []),
      condition: data['condition'] ?? 'New',
      hasElectricWarranty: data['hasElectricWarranty'] ?? false,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'brand': brand,
      'model': model,
      'year': year,
      'price': price,
      'images': images,
      'condition': condition,
      'hasElectricWarranty': hasElectricWarranty,
      'isActive': isActive,
    };
  }
}
