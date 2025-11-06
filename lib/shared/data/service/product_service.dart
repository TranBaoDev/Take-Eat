import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:take_eat/shared/data/model/product/product_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Product>> getAllProducts() async {
    final snapshot = await _db.collection('products').get();
    return snapshot.docs.map((doc) => Product.fromFirestore(doc.data(), doc.id)).toList();
  }
  /// Lấy danh sách category (unique) từ field 'categoryId'
  Future<List<String>> getCategories() async {
    try {
      final snapshot = await _db.collection('products').get();

      final categories = snapshot.docs
          .map((doc) => (doc.data()['categoryId'] ?? '').toString())
          .where((c) => c.isNotEmpty)
          .toSet()
          .toList();

      return categories;
    } catch (_) {
      rethrow;
    }
  }
  /// Lấy danh sách product theo categoryId
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      final snapshot = await _db
          .collection('products')
          .where('categoryId', isEqualTo: categoryId)
          .get();
      return snapshot.docs
          .map((doc) => Product.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (_) {
      rethrow;
    }
  }
}