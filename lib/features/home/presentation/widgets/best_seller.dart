import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/features/home/home_constant.dart';
import 'package:take_eat/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:take_eat/shared/data/repositories/product/product_repository.dart';

class BestSellerSection extends StatelessWidget {

  BestSellerSection({super.key});
  
  final ProductRepository repository = ProductRepository();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HomeConstant.commonPadding,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Best Seller',
                style: TextStyle(
                  fontFamily: 'League Spartan',
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All >',
                  style: TextStyle(
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: 12,
                    color: Color(0xFFE95322)
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 170,
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is HomeError) {
                  return const Center(child: Text("Lỗi tải dữ liệu"));
                }
                if (state is ProductsLoaded) {
                  final products = state.products;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Ảnh + badge giá
                            Container(
                              width: 150,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 3 / 4, 
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        product.image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFE95322),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30),
                                        ),
                                      ),
                                      child: Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}