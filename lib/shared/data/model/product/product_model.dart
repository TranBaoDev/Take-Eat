class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final double rating;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.rating,
    required this.description,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      image: data['image'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      description: data['description'] as String? ?? '',
    );
  }
}