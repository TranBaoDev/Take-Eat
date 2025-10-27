import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:take_eat/shared/data/model/product/product_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Product>> getAllProducts() async {
    final snapshot = await _db.collection('products').get();
    return snapshot.docs.map((doc) => Product.fromFirestore(doc.data(), doc.id)).toList();
  }

  Future<void> addProduct(Product product) {
    return _db.collection('products').add(product.toFirestore());
  }

}