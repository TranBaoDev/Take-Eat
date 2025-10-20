import 'package:flutter/material.dart';
import 'package:take_eat/core/asset/app_svgs.dart';
// Assuming necessary imports for _buildSearchBar and SvgPictureWidget

class AppBarSection extends StatelessWidget {
  const AppBarSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
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
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      ),
    );
  }
}