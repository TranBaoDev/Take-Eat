import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/asset/app_svgs.dart';
import 'package:take_eat/features/home/presentation/bloc/home_bloc.dart';
import 'package:take_eat/features/home/presentation/widgets/best_seller.dart';
import 'package:take_eat/features/home/presentation/widgets/recommended.dart';
import 'package:take_eat/shared/widgets/bottom_nav_bar.dart';
import 'package:take_eat/shared/widgets/category_section.dart';
import 'package:take_eat/features/home/presentation/widgets/promotion_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(LoadHomeData()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5CB58), // nền vàng ở trên
        body: SafeArea(
          bottom: false, // để container trắng có thể kéo xuống sát mép dưới
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              String greeting = 'Good Morning';
              if (state is HomeLoaded) {
                greeting = state.greeting;
              }

              return Stack(
                children: [
                  Positioned.fill(
                    top: 180,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(40),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CategorySection(),
                              SizedBox(height: 10),
                              BestSellerSection(),
                              PromotionCarousel(),
                              SizedBox(height: 20),
                              RecommendSection(),
                              SizedBox(height: 50)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 🔹 Header nổi phía trên (giữ màu vàng)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildSearchBar()),
                            const SizedBox(width: 10),
                            const Row(
                              children: [
                                SvgPictureWidget(
                                  assetName: SvgsAsset.iconCart,
                                  width: 32,
                                  height: 32,
                                ),
                                SizedBox(width: 5),
                                SvgPictureWidget(
                                  assetName: SvgsAsset.iconNotify,
                                  width: 32,
                                  height: 32,
                                ),
                                SizedBox(width: 5),
                                SvgPictureWidget(
                                  assetName: SvgsAsset.iconProfile,
                                  width: 32,
                                  height: 32,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          greeting,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Rise And Shine! It's Breakfast Time",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            color: Color(0xFFE95322),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: CustomBottomNavBar(currentIndex: 0),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // --------------------- PRIVATE UI BUILDERS --------------------- //

  static Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.tune, color: Color(0xFFE95322)),
          onPressed: () {},
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      ),
    );
  }
}
