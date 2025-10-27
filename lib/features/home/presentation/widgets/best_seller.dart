import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/features/home/presentation/bloc/home_bloc.dart';
import 'package:take_eat/shared/data/model/product/product_model.dart';
import 'package:take_eat/shared/data/repositories/product_repository.dart';

class BestSellerSection extends StatelessWidget {

  BestSellerSection({super.key});
  
  final ProductRepository repository = ProductRepository();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is HomeError) {
          return const Center(child: Text("Lỗi tải dữ liệu"));
        }
        if (state is ProductsLoaded) {
          final products = state.products;
          return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(product.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE95322),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
        }
        return const SizedBox.shrink();
      },
    );
  }
}