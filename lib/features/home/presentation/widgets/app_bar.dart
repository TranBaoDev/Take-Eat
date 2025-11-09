import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/core/asset/app_svgs.dart';
import 'package:take_eat/core/router/router.dart';
import 'package:take_eat/features/home/home_constant.dart';
import 'package:take_eat/features/home/presentation/bloc/filter/search_filter_bloc.dart';
import 'package:take_eat/features/home/presentation/screens/filter_screen.dart';

class AppBarSection extends StatelessWidget {
  const AppBarSection({
    super.key,
    required this.searchFilterBloc,
    this.onCartTap,
    this.onNotifyTap,
    this.onProfileTap,
  });

  final SearchFilterBloc searchFilterBloc;
  final VoidCallback? onCartTap;
  final VoidCallback? onNotifyTap;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFFF5CB58),
      elevation: 0,
      toolbarHeight: 70,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          child: Row(
            children: [
              Expanded(child: _buildSearchBar()),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onCartTap,
                child: const SvgPictureWidget(
                  assetName: SvgsAsset.iconCart,
                  width: 35,
                  height: 35,
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: onNotifyTap,
                child: const SvgPictureWidget(
                  assetName: SvgsAsset.iconNotify,
                  width: 35,
                  height: 35,
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: onProfileTap,
                child: const SvgPictureWidget(
                  assetName: SvgsAsset.iconProfile,
                  width: 35,
                  height: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return BlocProvider.value(
      value: searchFilterBloc,
      child: BlocBuilder<SearchFilterBloc, SearchFilterState>(
        builder: (context, state) {
          return Padding(
            padding: HomeConstant.commonPadding,
            child: SizedBox(
              height: 42,
              child: TextField(
                onChanged: (value) {
                  context.read<SearchFilterBloc>().add(
                    SearchQueryChanged(value),
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon: IconButton(
                    icon: Image.asset(AppAssets.iconFillter),
                    onPressed: () async {
                      await GoRouter.of(context).push(AppRoutes.filter);
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
