import 'package:take_eat/shared/data/model/product/product_model.dart';
import 'package:take_eat/shared/data/service/product_service.dart';

class ProductRepository {
  final ProductService _service = ProductService();

  Future<List<Product>> fetchAllProducts() => _service.getAllProducts();

}