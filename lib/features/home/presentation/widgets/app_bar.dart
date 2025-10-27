import 'package:flutter/material.dart';
import 'package:take_eat/core/asset/app_svgs.dart';

class AppBarSection extends StatelessWidget {
  const AppBarSection({
    super.key,
    this.onCartTap,
    this.onNotifyTap,
    this.onProfileTap,
  });

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
      ),
    );
  }
}
