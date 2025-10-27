import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:take_eat/features/setting/settings_constants.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'My Profile',
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is! AuthLoaded) {
            // fallback nếu chưa load xong user
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final size = MediaQuery.of(context).size;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: SettingsConstants.verticalPadding,
              horizontal: SettingsConstants.horizontalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🟦 Avatar vuông bo góc
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image(
                      image: state.photoUrl != null
                          ? NetworkImage(state.photoUrl!)
                          : const AssetImage(AppAssets.defaultAvatar)
                                as ImageProvider,
                      width: size.width * 0.4,
                      height: size.width * 0.4,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 🧍 Name
                _buildProfileRow('Full Name', state.name),

                // 📧 Email
                _buildProfileRow('Email', state.email ?? 'No email'),

                // 📱 Phone
                _buildProfileRow('Phone Number', state.phone ?? 'Not provided'),

                // 🎂 Birth Date
                _buildProfileRow(
                  'Birth Date',
                  state.birthDate ?? 'Not provided',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
