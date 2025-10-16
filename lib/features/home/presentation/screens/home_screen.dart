import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/asset/app_svgs.dart';
import 'package:take_eat/features/home/presentation/bloc/home_bloc.dart';
import 'package:take_eat/features/home/presentation/bloc/home_event.dart';
import 'package:take_eat/features/home/presentation/bloc/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

@override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(LoadHomeData()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5CB58),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state){
                String greeting = 'Good Morning';
                if (state is HomeLoaded) {
                  greeting = state.greeting;
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _buildSearchBar()), 
                        const SizedBox(width: 10),
                        const SvgPictureWidget(
                          assetName: SvgsAsset.iconCart,
                          width: 32,
                          height: 32,
                        ),
                        const SvgPictureWidget(
                          assetName: SvgsAsset.iconNotify,
                          width: 32,
                          height: 32,
                        ),
                        const SvgPictureWidget(
                          assetName: SvgsAsset.iconProfile,
                          width: 32,
                          height: 32,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      greeting,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
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
                    Container(
                      color: Colors.white,
                    )
                  ],
                );
              }),
          ),
        ),
      ),
    );
  }
  Widget _iconButton(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(icon, color: const Color(0xFFE95322)),
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.tune, color: Color(0xFFE95322)),
          onPressed: () {}, // Filter action
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

