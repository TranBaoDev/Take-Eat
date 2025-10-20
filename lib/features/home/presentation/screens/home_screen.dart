import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/asset/app_svgs.dart';
import 'package:take_eat/features/home/presentation/bloc/home_bloc.dart';
import 'package:take_eat/features/home/presentation/widgets/best_seller.dart';
import 'package:take_eat/features/home/presentation/widgets/recommended.dart';
import 'package:take_eat/features/home/presentation/widgets/app_bar.dart';
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
        backgroundColor: const Color(0xFFF5CB58),
        body: SafeArea(
          bottom: false,
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
                              // Remove extra SliverToBoxAdapter, use CategorySection directly
                              CategorySection(),
                              SizedBox(height: 10),
                              BestSellerSection(),
                              PromotionCarousel(),
                              SizedBox(height: 20),
                              RecommendSection(),
                              SizedBox(height: 50),
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
                        AppBarSection(),
                        SizedBox(height: 10),
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
        // bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
      ),
    );
  }
}