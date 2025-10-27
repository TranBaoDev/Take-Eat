import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/di/get_in.dart';
import 'package:take_eat/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:take_eat/features/cart/blocs/cart_bloc.dart';
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
import 'package:take_eat/features/home/presentation/widgets/category_section.dart';

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
        BlocProvider(
          create: (_) => LikesBloc(getIt<LikeRepository>()),
        )

      ],
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF5CB58),
        drawer: currentDrawerType != null
            ? CustomDrawer(type: currentDrawerType!)
            : null,
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  final bool isProductView = state is ProductsLoaded;
                  
                  return CustomScrollView(
                    slivers: [
                      AppBarSection(
                        onCartTap: () => _openDrawer(DrawerType.cart),
                        onNotifyTap: () => _openDrawer(DrawerType.notify),
                        onProfileTap: () => _openDrawer(DrawerType.profile),
                      ),
                      if (!isProductView) ...[
                        SliverPadding(
                          padding: const EdgeInsets.all(16),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    state is HomeLoaded ? state.greeting : 'Good Morning',
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
                            ]),
                          ),
                        ),
                      ],
                      SliverToBoxAdapter(
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(40),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CategorySection(),
                                    const SizedBox(height: 20),
                                    BlocBuilder<HomeBloc, HomeState>(
                                      builder: (context, state) {
                                        if (state is ProductsLoaded) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Sort By: ',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                      const Text(
                                                        'Popular',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Color(0xFFE95322),
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.tune),
                                                    onPressed: () {},
                                                    color: const Color(0xFFE95322),
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
                                                  return Padding(
                                                    padding: const EdgeInsets.only(bottom: 16),
                                                    child: AnimatedContainer(
                                                      duration: Duration(milliseconds: 300 + (index * 100)),
                                                      curve: Curves.easeInOut,
                                                      transform: Matrix4.translationValues(0, 0, 0)..translate(
                                                        0.0,
                                                        index.isEven ? -20.0 : 20.0,
                                                        0.0,
                                                      ),
                                                      child: Card(
                                                        elevation: 4,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: SizedBox(
                                                          height: 120,
                                                          child: Row(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius: const BorderRadius.horizontal(
                                                                  left: Radius.circular(12),
                                                                ),
                                                                child: Image.network(
                                                                  product.image,
                                                                  width: 120,
                                                                  height: 120,
                                                                  fit: BoxFit.cover,
                                                                  errorBuilder: (context, error, stackTrace) {
                                                                    return Container(
                                                                      color: Colors.grey[200],
                                                                      width: 120,
                                                                      height: 120,
                                                                      child: const Icon(Icons.image_not_supported),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(12),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                '${product.name} • ',
                                                                                style: const TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 16,
                                                                                ),
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                              Container(
                                                                                padding: const EdgeInsets.symmetric(
                                                                                  horizontal: 8,
                                                                                  vertical: 4,
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                  color: const Color(0xFFE95322),
                                                                                  borderRadius: BorderRadius.circular(12),
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    const Icon(
                                                                                      Icons.star,
                                                                                      color: Colors.white,
                                                                                      size: 16,
                                                                                    ),
                                                                                    const SizedBox(width: 4),
                                                                                    Text(
                                                                                      product.rating.toString(),
                                                                                      style: const TextStyle(
                                                                                        color: Colors.white,
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(height: 4),
                                                                          Text(
                                                                            'Chips With Toppings',
                                                                            style: const TextStyle(
                                                                              fontSize: 14,
                                                                            ),
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            '\$${product.price.toStringAsFixed(2)}',
                                                                            style: const TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16,
                                                                              color: Color(0xFFE95322),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            padding: const EdgeInsets.all(4),
                                                                            decoration: const BoxDecoration(
                                                                              color: Color(0xFFE95322),
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child: const Icon(
                                                                              Icons.add,
                                                                              color: Colors.white,
                                                                              size: 20,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                    if (state is! ProductsLoaded) ...[
                                      const SizedBox(height: 20),
                                      BestSellerSection(),
                                      const PromotionCarousel(),
                                      const SizedBox(height: 20),
                                      const RecommendSection(),
                                      const SizedBox(height: 50),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavBar(currentIndex: 0),
            ),
          ],
        ),
      ),
    );
  }
}
