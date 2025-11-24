class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String imageUrl;
  final String description;
  final Map<String, dynamic> specs;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.specs,
    this.rating = 0.0,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      specs: data['specs'] ?? {},
      rating: (data['rating'] ?? 0).toDouble(),
    );
  }
}