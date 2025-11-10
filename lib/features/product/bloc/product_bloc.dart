// product_bloc.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:take_eat/shared/data/model/product/product_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this.firestore) : super(ProductInitial()) {
    on<FetchProductEvent>(_onFetchProduct);
  }
  final FirebaseFirestore firestore;

  Future<void> _onFetchProduct(
    FetchProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final doc = await firestore
          .collection('products')
          .doc(event.productId)
          .get();

      if (!doc.exists) {
        emit(ProductError('Product not found'));
        return;
      }

      final data = doc.data()!;
      final product = Product.fromFirestore(data, doc.id);
      emit(ProductLoaded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
