// product_detail_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/di/get_in.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/features/cart/blocs/cart_bloc.dart';
import 'package:take_eat/features/home/presentation/bloc/like/likes_bloc.dart';
import 'package:take_eat/features/home/presentation/bloc/like/likes_event.dart';
import 'package:take_eat/features/home/presentation/bloc/like/likes_state.dart';
import 'package:take_eat/features/product/bloc/product_bloc.dart';
import 'package:take_eat/shared/data/model/cart/cart_item.dart';
import 'package:take_eat/shared/data/model/product/product_model.dart';
import 'package:take_eat/shared/widgets/app_btn.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';
import 'package:uuid/uuid.dart';

// Simple topping model used only in this screen. Kept private.
class _Topping {
  final String id;
  final String name;
  final double price;
  const _Topping(this.id, this.name, this.price);
}

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({required this.productId, super.key});
  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  // Available toppings for the product (could be loaded from backend later)
  final List<_Topping> _availableToppings = const [
    _Topping('t1', 'Topping1', 2.99),
    _Topping('t2', 'Topping2', 3.99),
    _Topping('t3', 'Topping3', 3.99),
    _Topping('t4', 'Topping4', 2.99),
  ];

  final Set<String> _selectedToppingIds = <String>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure Likes are loaded so isLiked stays in sync across screens
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
      final likesBloc = context.read<LikesBloc>();
      final isLoaded = likesBloc.state.maybeWhen(
        loaded: (ids) => true,
        orElse: () => false,
      );
      if (!isLoaded) {
        likesBloc.add(LikesEvent.loadLikes(userId));
      }
    } catch (_) {
      // If LikesBloc is not available in the tree, ignore — RecommendSection/App should provide it
    }
  }

  double _calculateTotal(Product product) {
    final toppingSum = _availableToppings
        .where((t) => _selectedToppingIds.contains(t.id))
        .fold<double>(0.0, (p, e) => p + e.price);
    final unit = product.price + toppingSum;
    return unit * _quantity;
  }

  void _addToCart(BuildContext context, Product product) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    const uuid = Uuid();

    // Create cart item with selected toppings and quantity
    final toppingNames = _availableToppings
        .where((t) => _selectedToppingIds.contains(t.id))
        .map((t) => t.name)
        .toList();

    final cartItem = CartItem(
      id: uuid.v4(),
      userId: userId,
      name: toppingNames.isEmpty
          ? product.name
          : '${product.name} (${toppingNames.join(", ")})',
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
            final bloc = getIt<ProductBloc>()
              ..add(FetchProductEvent(widget.productId));
            return bloc;
          },
        ),
        BlocProvider(
          create: (context) => getIt<CartBloc>(),
        ),
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

              return BlocBuilder<LikesBloc, LikesState>(
                builder: (context, likeState) {
                  // derive the set of liked ids from LikesState (matches RecommendSection)
                  final likedIds = likeState.maybeWhen(
                    loaded: (Set<String> ids) => ids,
                    orElse: () => <String>{},
                  );
                  final isLiked = likedIds.contains(
                    product.id,
                  );
                  return AppScaffold(
                    title: product.name.padRight(35),
                    headerTrailing: _ratingHeader(product, isLiked),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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

                                      // Toppings
                                      const Text(
                                        'Toppings',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: _availableToppings.length,
                                        separatorBuilder: (_, __) =>
                                            const Divider(),
                                        itemBuilder: (context, index) {
                                          final t = _availableToppings[index];
                                          final selected = _selectedToppingIds
                                              .contains(t.id);
                                          return InkWell(
                                            onTap: () => setState(() {
                                              if (selected) {
                                                _selectedToppingIds.remove(
                                                  t.id,
                                                );
                                              } else {
                                                _selectedToppingIds.add(t.id);
                                              }
                                            }),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                  ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      t.name,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    '\$${t.price.toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: selected
                                                            ? AppColors.primary
                                                            : Colors.grey,
                                                      ),
                                                      color: selected
                                                          ? AppColors.primary
                                                          : Colors.white,
                                                    ),
                                                    child: selected
                                                        ? const Icon(
                                                            Icons.check,
                                                            size: 14,
                                                            color: Colors.white,
                                                          )
                                                        : const SizedBox.shrink(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
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
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _ratingHeader(Product product, bool isLiked) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                product.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.star, color: Colors.amber, size: 14),
            ],
          ),
        ),
        SizedBox(width: 10),
        _isLikedButton(product, isLiked),
      ],
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
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: Container(
          key: ValueKey<bool>(isLiked),
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.favorite,
            size: 18,
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
