import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/di/get_in.dart';
import 'package:take_eat/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:take_eat/features/cart/blocs/cart_bloc.dart';
import 'package:take_eat/features/category/presentation/screens/category_detail.dart';
import 'package:take_eat/features/home/home_constant.dart';
import 'package:take_eat/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:take_eat/features/home/presentation/bloc/like/likes_bloc.dart';
import 'package:take_eat/features/home/presentation/widgets/app_bar.dart';
import 'package:take_eat/features/home/presentation/widgets/best_seller.dart';
import 'package:take_eat/features/home/presentation/widgets/promotion_banner.dart';
import 'package:take_eat/features/home/presentation/widgets/recommended.dart';
import 'package:take_eat/shared/data/repositories/cart/cart_repository.dart';
import 'package:take_eat/shared/data/repositories/like/like_repository.dart';
import 'package:take_eat/shared/widgets/app_drawer.dart';
import 'package:take_eat/shared/widgets/bottom_nav_bar.dart';
import 'package:take_eat/features/category/presentation/widgets/category_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DrawerType? currentDrawerType;
  String? selectedCategory;

  void _openDrawer(DrawerType type) {
    setState(() => currentDrawerType = type);
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onCategorySelected(String category) {
    setState(() {
      setState(() => selectedCategory = category.isEmpty ? null : category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeBloc()..add(const LoadHomeData()),
        ),
        BlocProvider(
          create: (_) => AuthCubit()..loadCurrentUser(),
        ),
        BlocProvider(
          create: (context) => CartBloc(CartRepository()),
        ),
        BlocProvider(
          create: (_) => LikesBloc(getIt<LikeRepository>()),
        ),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF5CB58),
        drawer: currentDrawerType != null
            ? CustomDrawer(type: currentDrawerType!)
            : null,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // 1) App bar section as a sliver
                  AppBarSection(
                    onCartTap: () => _openDrawer(DrawerType.cart),
                    onNotifyTap: () => _openDrawer(DrawerType.notify),
                    onProfileTap: () => _openDrawer(DrawerType.profile),
                  ),

                  // 2) Greeting — HomeState (BlocBuilder)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          final greetingText = state is HomeLoaded
                              ? state.greeting
                              : 'Good Morning';
                          return Padding(
                            padding: HomeConstant.commonPadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  greetingText,
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
                          );
                        },
                      ),
                    ),
                  ),

                  // 3) White rounded container top
                  SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CategorySection(
                              onCategorySelected: _onCategorySelected,
                            ),
                            const SizedBox(height: 20),

                            const SizedBox(height: 20),
                            if (selectedCategory == null) ...[
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0xFFFFD8C7),
                              ),
                              BestSellerSection(),
                              const PromotionCarousel(),
                              const RecommendSection(),
                            ] else
                              const CategoryDetail(),

                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Bottom nav fixed
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CustomBottomNavBar(currentIndex: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}