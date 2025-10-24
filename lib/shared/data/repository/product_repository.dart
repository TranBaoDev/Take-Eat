import 'package:take_eat/shared/data/model/product/product_model.dart';
import 'package:take_eat/shared/data/service/product_service.dart';

class ProductRepository {
  final ProductService _service = ProductService();

  Stream<List<Product>> fetchProducts() => _service.getProducts();

  Future<void> add(Product product) => _service.addProduct(product);
}