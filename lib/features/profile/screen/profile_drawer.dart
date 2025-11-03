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
    final user = FirebaseAuth.instance.currentUser;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Phần user info: load trực tiếp từ Firebase ---
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : const AssetImage(AppAssets.defaultAvatar)
                          as ImageProvider,
              ),

              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? 'Unknown User',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser?.email ?? 'No email',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // --- Các menu item vẫn giữ nguyên ---
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
            onTap: () {
              GoRouter.of(context).go(AppRoutes.paymentMethods);
            },
            title: 'Payment Methods',
          ),
          _buildMenuItem(
            assetName: SvgsAsset.iconContacts,
            onTap: () {
              GoRouter.of(context).go(AppRoutes.contactUs);
            },
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
              context.go(AppRoutes.setting);
            },
            title: 'Settings',
          ),
          const Spacer(),
          const Divider(color: Colors.white54),
          _buildMenuItem(
            assetName: SvgsAsset.iconLogout,
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                context.go(AppRoutes.authScreen);
              }
            },
            title: 'Sign out',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String assetName,
    required String title,
    VoidCallback? onTap,
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
