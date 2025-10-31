import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/features/home/home_constant.dart';

class PromotionCarousel extends StatefulWidget {
  const  PromotionCarousel({super.key});

  @override
  State<PromotionCarousel> createState() => _PromotionCarouselState();
}

class _PromotionCarouselState extends State<PromotionCarousel> {
  int _currentIndex = 0;

  final List<Map<String, String>> banners = [
    {
      'title1': 'Experience our',
      'title2': 'delicious new dish',
      'discount': '30% OFF',
      'image': AppAssets.bannerImage,
    },
    {
      'title1': 'Try our new',
      'title2': 'special burger combo',
      'discount': '25% OFF',
      'image': AppAssets.bannerImage,
    },
    {
      'title1': 'Taste fresh',
      'title2': 'Japanese sushi rolls',
      'discount': '20% OFF',
      'image': AppAssets.bannerImage,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HomeConstant.commonPadding,
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: banners.length,
            itemBuilder: (context, index, realIndex) {
              final item = banners[index];
              return _buildBannerItem(item);
            },
            options: CarouselOptions(
              height: 150,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() => _currentIndex = index);
              },
            ),
          ),
          const SizedBox(height: 10),
          _buildIndicator(),
        ],
      ),
    );
  }

  Widget _buildBannerItem(Map<String, String> item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFFE95322)
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title1']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    item['title2']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['discount']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.asset(
                item['image']!,
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(banners.length, (index) {
        final isActive = _currentIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: isActive ? 20 : 12,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFF7C35) : const Color(0xFFF3E7C0),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}
