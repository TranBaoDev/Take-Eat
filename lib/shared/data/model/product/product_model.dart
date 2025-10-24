class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final double rating;
  bool liked;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.rating,
    required this.liked
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] as String? ?? '',
      price: (data['price'] as num).toDouble(),
      image: data['image'] as String? ?? '',
      liked: data['like'] as bool? ?? false,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'image': image,
    };
  }
}