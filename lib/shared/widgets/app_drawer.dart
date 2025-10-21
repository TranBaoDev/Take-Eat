import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/core/asset/app_svgs.dart';
import 'package:take_eat/features/auth/presentation/cubit/auth_cubit.dart';

enum DrawerType { profile, cart, notify }

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({required this.type, super.key});
  final DrawerType type;

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (type) {
      case DrawerType.profile:
        content = _buildProfileDrawer(context);
        break;
      case DrawerType.cart:
        content = _buildCartDrawer(context);
        break;
      case DrawerType.notify:
        content = _buildNotifyDrawer(context);
        break;
    }

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      backgroundColor: const Color(0xFFE95322),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(child: content),
    );
  }

  /// Drawer hồ sơ người dùng
  /// Drawer hồ sơ người dùng
  Widget _buildProfileDrawer(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          // Hiển thị loading khi đang tải dữ liệu
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (state is AuthLoaded) {
          // Use data from state to display pfp, name
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display profile picture (pfp) from state.photoUrl
                CircleAvatar(
                  radius: 28,
                  backgroundImage: state.photoUrl != null
                      ? NetworkImage(state.photoUrl!)
                      : const AssetImage(AppAssets.defaultAvatar)
                            as ImageProvider,
                ),
                const SizedBox(height: 12),
                // Hiển thị tên từ state.name
                Text(
                  state.name ?? 'Unknown User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Email can be retrieved from FirebaseAuth or added to state if needed
                Text(
                  FirebaseAuth.instance.currentUser?.email ?? 'No email',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 30),
                _buildMenuItem(SvgsAsset.iconMyOrder, 'My Orders'),
                _buildMenuItem(SvgsAsset.iconProfile, 'My Profile'),
                _buildMenuItem(SvgsAsset.iconAddress, 'Delivery Address'),
                _buildMenuItem(SvgsAsset.iconPayment, 'Payment Methods'),
                _buildMenuItem(SvgsAsset.iconContacts, 'Contact Us'),
                _buildMenuItem(SvgsAsset.iconSettings, 'Settings'),
                const Spacer(),
                const Divider(color: Colors.white54),
                _buildMenuItem(SvgsAsset.iconLogout, 'Log Out'),
              ],
            ),
          );
        }

        if (state is AuthError) {
          // Error handling: fallback or display message
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 64),
                const SizedBox(height: 16),
                Text(
                  state.userMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Call loadCurrentUser from cubit
                    context.read<AuthCubit>().loadCurrentUser();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Fallback if state is different (e.g. AuthInitial)
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Please log in to view profile',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  /// Drawer giỏ hàng
  Widget _buildCartDrawer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Cart',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.fastfood, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Pizza Margherita',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const Text(
                      '\$12.99',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Drawer thông báo
  Widget _buildNotifyDrawer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  leading: Icon(Icons.notifications, color: Colors.white),
                  title: Text(
                    'Your order #1234 is on the way!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.notifications, color: Colors.white),
                  title: Text(
                    '50% off on desserts today!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String assetName, String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: GestureDetector(
        onTap:
            onTap ?? () {}, // Nếu onTap null, thì không làm gì (fallback rỗng)
        child: Row(
          children: [
            SvgPictureWidget(
              assetName: assetName,
              width: 35,
              height: 35,
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
