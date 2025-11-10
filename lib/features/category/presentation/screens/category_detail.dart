// ignore_for_file: inference_failure_on_instance_creation

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/features/category/presentation/widgets/product_card.dart';
import 'package:take_eat/features/home/home_constant.dart';
import 'package:take_eat/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:take_eat/features/home/presentation/home.dart';

class CategoryDetail extends StatelessWidget {
  const CategoryDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is ProductsLoaded) {
          return Padding(
            padding: HomeConstant.commonPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Sort By ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const Text(
                          'Popular',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune),
                      onPressed: () {},
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];

                    return ProductCard(
                      product: product,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
