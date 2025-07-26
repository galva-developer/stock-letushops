// 📦 Product Model
// Modelo de datos para productos

class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int stock;
  final List<String> images;
  final Map<String, dynamic> characteristics;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? barcode;
  final String? brand;
  final String? model;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.stock,
    required this.images,
    required this.characteristics,
    required this.createdAt,
    required this.updatedAt,
    this.barcode,
    this.brand,
    this.model,
  });

  // Crear desde JSON (Firebase)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      characteristics: Map<String, dynamic>.from(json['characteristics'] ?? {}),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] ?? 0),
      barcode: json['barcode'],
      brand: json['brand'],
      model: json['model'],
    );
  }

  // Convertir a JSON (Firebase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'stock': stock,
      'images': images,
      'characteristics': characteristics,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'barcode': barcode,
      'brand': brand,
      'model': model,
    };
  }

  // Copiar con modificaciones
  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? price,
    int? stock,
    List<String>? images,
    Map<String, dynamic>? characteristics,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? barcode,
    String? brand,
    String? model,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      images: images ?? this.images,
      characteristics: characteristics ?? this.characteristics,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      barcode: barcode ?? this.barcode,
      brand: brand ?? this.brand,
      model: model ?? this.model,
    );
  }

  // Verificar si está en stock bajo
  bool get isLowStock => stock < 10;

  // Verificar si está sin stock
  bool get isOutOfStock => stock == 0;

  // Obtener nivel de stock
  String get stockLevel {
    if (isOutOfStock) return 'Sin Stock';
    if (isLowStock) return 'Stock Bajo';
    if (stock < 50) return 'Stock Medio';
    return 'Stock Alto';
  }
}
