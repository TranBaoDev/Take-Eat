import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/core/asset/app_svgs.dart';
import 'package:take_eat/core/router/router.dart';
import 'package:take_eat/features/auth/presentation/cubit/auth_cubit.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
                _buildMenuItem(
                  assetName: SvgsAsset.iconMyOrder,
                  onTap: () {},
                  title: 'My Orders',
                ),
                _buildMenuItem(
                  assetName: SvgsAsset.iconProfile,
                  onTap: () {
                    GoRouter.of(context).go(AppRoutes.myProfile);
                  },
                  title: 'My Profile',
                ),
                _buildMenuItem(
                  assetName: SvgsAsset.iconAddress,
                  onTap: () {},
                  title: 'Delivery Address',
                ),
                _buildMenuItem(
                  assetName: SvgsAsset.iconPayment,
                  onTap: () {},
                  title: 'Payment Methods',
                ),
                _buildMenuItem(
                  assetName: SvgsAsset.iconContacts,
                  onTap: () {},
                  title: 'Contact Us',
                ),
                _buildMenuItem(
                  assetName: SvgsAsset.iconFAQs,
                  onTap: () {},
                  title: 'Help & FAQs',
                ),
                _buildMenuItem(
                  assetName: SvgsAsset.iconSettings,
                  onTap: () {
                    context.go( AppRoutes.setting);
                  },
                  title: 'Settings',
                ),
                const Spacer(),
                const Divider(color: Colors.white54),
                _buildMenuItem(
                  assetName: SvgsAsset.iconLogout,
                  onTap: () async {
                    await context.read<AuthCubit>().signOut();
                    unawaited(
                      GoRouter.of(
                        context,
                      ).replace(AppRoutes.authScreen),
                    );
                  },
                  title: 'Sign out',
                ),
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

  Widget _buildMenuItem({
    VoidCallback? onTap,
    required String assetName,
    required String title,
  }) {
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
