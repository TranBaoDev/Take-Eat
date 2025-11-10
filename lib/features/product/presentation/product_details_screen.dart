// product_detail_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/di/get_in.dart';
import 'package:take_eat/core/styles/colors.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/features/cart/blocs/cart_bloc.dart';
import 'package:take_eat/features/home/presentation/bloc/like/likes_bloc.dart';
import 'package:take_eat/features/home/presentation/bloc/like/likes_event.dart';
import 'package:take_eat/features/product/bloc/product_bloc.dart';
import 'package:take_eat/shared/data/model/cart/cart_item.dart';
import 'package:take_eat/shared/data/model/product/product_model.dart';
import 'package:take_eat/shared/widgets/app_btn.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';
import 'package:uuid/uuid.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({required this.productId, super.key});
  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  double _calculateTotal(Product product) {
    return product.price * _quantity;
  }

  void _addToCart(BuildContext context, Product product) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    const uuid = Uuid();

    // Create cart item with selected toppings and quantity
    final cartItem = CartItem(
      id: uuid.v4(),
      userId: userId,
      name: product.name,
      price: _calculateTotal(product),
      image: product.image,
      dateTime: DateTime.now(),
      quantity: _quantity,
    );

    context.read<CartBloc>().add(CartEvent.addToCart(cartItem));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} đã được thêm vào giỏ hàng!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final bloc = getIt<ProductBloc>();
            bloc.add(FetchProductEvent(widget.productId));
            return bloc;
          },
        ),
        BlocProvider(
          create: (context) => getIt<CartBloc>(),
        ),
        BlocProvider(create: (context) => getIt<LikesBloc>()),
      ],
      child: Builder(
        builder: (context) => BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            } else if (state is ProductLoaded) {
              final product = state.product;

              return AppScaffold(
                title: product.name,
                body: SafeArea(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            Container(
                              width: double.infinity,
                              height: 250,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(product.image),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BlocListener<LikesBloc, LikesState>(
                                    listener: (context, state) {
                                      // TODO: implement listener
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.name,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        //TODO ad isliked button
                                        _isLikedButton(product, state.isLiked),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '\$${_calculateTotal(product).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      // Quantity selector
                                      _priceSelection(),
                                      const SizedBox(
                                        height: 100,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.description,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Space for bottom button
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Bottom Add to Cart button
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, -2),
                              ),
                            ],
                          ),
                          child: AppBtnWidget(
                            text: 'Add to Cart',
                            bgColor: AppColors.primary,
                            textColor: Colors.white,
                            onTap: () => _addToCart(context, product),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _isLikedButton(Product product, bool isLiked) {
    return GestureDetector(
      onTap: () {
        final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
        context.read<LikesBloc>().add(
          LikesEvent.toggleLike(
            userId: userId,
            productId: product.id,
            currentLiked: isLiked,
          ),
        );
      },
      child: AnimatedScale(
        scale: isLiked ? 1.2 : 1.0,
        duration: const Duration(
          milliseconds: 200,
        ),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.favorite,
            size: 14,
            color: isLiked ? Colors.red : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _priceSelection() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.remove_circle_outline,
            size: 24,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          color: AppColors.primary,
          onPressed: () {
            if (_quantity > 1) {
              setState(() => _quantity--);
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          child: Text(
            _quantity.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.add_circle_outline,
            size: 24,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          color: AppColors.primary,
          onPressed: () {
            setState(() => _quantity++);
          },
        ),
      ],
    );
  }
}
