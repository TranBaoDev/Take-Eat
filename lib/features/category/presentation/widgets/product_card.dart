import 'package:flutter/material.dart';
import 'package:take_eat/app/app.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/core/theme/app_text_styles.dart';
import 'package:take_eat/shared/data/model/product/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            // Image
            Container(
              width: 323,
              height: 174,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                image: DecorationImage(
                  image: NetworkImage(product.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name
                    Text(
                      '${product.name[0].toUpperCase()}${product.name.substring(1)}',
                      style: AppTextStyles.nameProduct,
                    ),

                    // Dot
                    const SizedBox(width: 4),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),

                    // Rating + Star
                    Container(
                      width: 38,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Image.asset(
                            AppAssets.iconStar,
                            width: 9,
                            fit: BoxFit.cover,
                            color: const Color(0xFFF4BA1B),
                          ),
                        ],
                      ),
                    ),

                    // Price
                    const SizedBox(width: 8),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: AppTextStyles.priceProduct,
                    ),
                  ],
                ),

                // Description
                Text(product.description, style: AppTextStyles.textDes),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.dividerColor,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
