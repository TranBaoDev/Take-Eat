import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:take_eat/shared/data/model/product/product_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromFirestore(doc.data(), doc.id)).toList());
  }

  Future<void> addProduct(Product product) {
    return _db.collection('products').add(product.toFirestore());
  }

}