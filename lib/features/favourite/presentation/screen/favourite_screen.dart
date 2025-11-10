import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:take_eat/features/home/presentation/bloc/like/likes_bloc.dart';
import 'package:take_eat/features/home/presentation/bloc/like/likes_event.dart';
import 'package:take_eat/features/home/presentation/bloc/like/likes_state.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';
import 'package:take_eat/shared/widgets/bottom_nav_bar.dart';
class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const HomeEvent.loadProducts());
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    context.read<LikesBloc>().add(LikesEvent.loadLikes(userId));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Favourite',
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, homeState) {
          if (homeState is ProductsLoaded) {
            final allProducts = homeState.products;

            return BlocBuilder<LikesBloc, LikesState>(
              builder: (context, likesState) {
                if (likesState is LikesLoaded) {
                  final favouriteProducts = allProducts
                      .where((product) =>
                          likesState.likedProductIds.contains(product.id))
                      .toList();

                  if (favouriteProducts.isEmpty) {
                    return const Center(
                      child: Text('You have no favourite products yet.'),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          "It's time to buy your favourite dish.",
                          style: TextStyle(
                            color: AppColors.textOrange,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: favouriteProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            final product = favouriteProducts[index];
                            return FoodCard(
                              imagePath: product.image,
                              title: product.name,
                              description: product.description,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }

                if (likesState is LikesLoading || likesState is LikesInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (likesState is LikesError) {
                  return Center(child: Text(likesState.message));
                }

                return const SizedBox();
              },
            );
          }

          if (homeState is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (homeState is HomeError) {
            return Center(child: Text(homeState.error));
          }

          return const SizedBox();
        },
      ),
    );
  }
}


class FoodCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String description;
  const FoodCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  color: Colors.grey[300],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    widget.imagePath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.fastfood,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),

              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B35),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
