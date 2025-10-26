import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:take_eat/features/cart/blocs/cart_bloc.dart';
import 'package:take_eat/features/home/presentation/bloc/home_bloc.dart';
import 'package:take_eat/features/home/presentation/widgets/app_bar.dart';
import 'package:take_eat/features/home/presentation/widgets/best_seller.dart';
import 'package:take_eat/features/home/presentation/widgets/promotion_banner.dart';
import 'package:take_eat/features/home/presentation/widgets/recommended.dart';
import 'package:take_eat/shared/data/repositories/cart/cart_repository.dart';
import 'package:take_eat/shared/widgets/app_drawer.dart';
import 'package:take_eat/shared/widgets/bottom_nav_bar.dart';
import 'package:take_eat/shared/widgets/category_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DrawerType? currentDrawerType;

  void _openDrawer(DrawerType type) {
    setState(() => currentDrawerType = type);
    _scaffoldKey.currentState?.openDrawer();
  }
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeBloc()..add(const LoadHomeData()),
        ),
        BlocProvider(
          create:(_) => HomeBloc()..add(const LoadProducts()), 
        ),
        BlocProvider(
          create: (_) => AuthCubit()..loadCurrentUser(),
        ),
        BlocProvider(
          create: (context) => CartBloc(CartRepository()),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CategorySection(),
                              const SizedBox(height: 10),
                              BestSellerSection(),
                              const PromotionCarousel(),
                              const SizedBox(height: 20),
                              const RecommendSection(),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 🔹 Header vàng (AppBar + Greeting)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBarSection(
                          onCartTap: () => _openDrawer(DrawerType.cart),
                          onNotifyTap: () => _openDrawer(DrawerType.notify),
                          onProfileTap: () => _openDrawer(DrawerType.profile),
                        ),
                        const SizedBox(height: 10),
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

                  // 🔹 Bottom navigation
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
}
