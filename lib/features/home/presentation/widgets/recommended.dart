// ignore_for_file: inference_failure_on_instance_creation

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/core/utils/utils.dart';
import 'package:take_eat/features/cart/blocs/cart_bloc.dart';
import 'package:take_eat/features/home/home_constant.dart';
import 'package:take_eat/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:take_eat/features/home/presentation/bloc/like/likes_bloc.dart';
import 'package:take_eat/features/home/presentation/bloc/like/likes_event.dart';
import 'package:take_eat/features/home/presentation/bloc/like/likes_state.dart';
import 'package:take_eat/features/home/presentation/screens/home_screen.dart';
import 'package:take_eat/shared/data/model/cart/cart_item.dart';
import 'package:take_eat/shared/data/model/product/product_model.dart';
import 'package:take_eat/shared/data/repositories/product/product_repository.dart';
import 'package:uuid/uuid.dart';

class RecommendSection extends StatefulWidget {
  const RecommendSection({super.key});

  @override
  State<RecommendSection> createState() => _RecommendSectionState();
}

class _RecommendSectionState extends State<RecommendSection> {
  final ProductRepository repository = ProductRepository();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const HomeEvent.loadProducts());
    // Load likes using bloc from context
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    context.read<LikesBloc>().add(LikesEvent.loadLikes(userId));
  }

  void _addToCart(Product product) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    const uuid = Uuid();
    final cartItem = CartItem(
      id: uuid.v4(),
      userId: userId,
      name: product.name,
      price: product.price,
      image: product.image,
      dateTime: DateTime.now(),
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
    return Padding(
      padding: HomeConstant.commonPadding,
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                'Recommend',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3C1E1E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is HomeError) {
                return const Center(child: Text("Lỗi tải dữ liệu 😢"));
              }
              if (state is ProductsLoaded) {
                final products = state.products;
                return FutureBuilder<List<Product>>(
                  future: filterValidImages(products),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snap.hasError || !snap.hasData || snap.data!.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final validProducts = snap.data!;
                    return BlocBuilder<LikesBloc, LikesState>(
                      builder: (context, likesState) {
                        final likedIds = likesState.maybeWhen(
                          loaded: (Set<String> ids) => ids,
                          orElse: () => <String>{},
                        );
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: validProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.1,
                              ),
                          itemBuilder: (context, index) {
                            final product = validProducts[index];
                            final isLiked = likedIds.contains(product.id);
                            return GestureDetector(
                              onTap: () => _addToCart(product),
                              child: _buildProductItem(product, isLiked),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  /// 🎨 UI 1 sản phẩm
  Widget _buildProductItem(Product product, bool isLiked) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(
                product.image.isNotEmpty ? product.image : AppAssets.sushiImage,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black.withOpacity(0.05),
          ),
        ),

        // ⭐ Rating + ❤️ Like
        Positioned(
          top: 8,
          left: 8,
          right: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ⭐ Rating
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                  ],
                ),
              ),

              // ❤️ Heart icon (with animation) - wired to LikesBloc
              GestureDetector(
                onTap: () {
                  final userId =
                      FirebaseAuth.instance.currentUser?.uid ?? 'guest';
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
                  duration: const Duration(milliseconds: 200),
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
              ),
            ],
          ),
        ),

        // 💰 Giá
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
