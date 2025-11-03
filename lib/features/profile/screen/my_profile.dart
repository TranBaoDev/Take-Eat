import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/core/router/router.dart';
import 'package:take_eat/core/styles/colors.dart';
import 'package:take_eat/features/profile/bloc/my_profile_bloc.dart';
import 'package:take_eat/shared/data/repositories/user_repository.dart';
import 'package:take_eat/shared/widgets/app_btn.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';

/// Profile screen: minimal UI that delegates parsing/normalization to MyProfileBloc.
class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();

  MyProfileBloc? _bloc;

  @override
  void initState() {
    super.initState();
    try {
      _bloc = MyProfileBloc(userRepository: UserRepository());
      _bloc!.add(LoadMyProfile());
    } catch (e) {
      // If bloc construction fails, keep the UI alive and show an error message.
      // ignore: avoid_print
      print('MyProfileBloc init failed: $e');
      _bloc = null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    // Close the bloc but do not await in dispose — dispose must be synchronous
    _bloc?.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      return const AppScaffold(
        title: 'My Profile',
        body: Center(child: Text('Failed to initialize profile.')),
      );
    }

    return BlocProvider.value(
      value: _bloc!,
      child: AppScaffold(
        title: 'My Profile',
        body: BlocBuilder<MyProfileBloc, MyProfileState>(
          builder: (context, state) {
            if (state is MyProfileLoading || state is MyProfileInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MyProfileError) {
              if (state.message.contains('not signed in')) {
                // điều hướng về login
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  GoRouter.of(context).go(AppRoutes.authScreen);
                });
                return const SizedBox.shrink(); // tránh build UI lỗi
              }

              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is MyProfileLoaded || state is MyProfileUpdating) {
              // use a single locally-typed variable so we can treat Loaded and
              // Updating uniformly (Updating now carries the same fields)
              final dynamic profile = state as dynamic;

              // populate controllers only when different to avoid overwriting user edits
              final String _profileName = (profile.name as String?) ?? '';
              final String _profilePhone = (profile.phone as String?) ?? '';
              if (_nameController.text != _profileName)
                _nameController.text = _profileName;
              if (_phoneController.text != _profilePhone)
                _phoneController.text = _profilePhone;

              // Initialize birth controller once from the bloc-provided formatted
              // value so the DateFormatField displays the DOB on first build.
              final String _initialBirth =
                  (profile.birthFormatted as String?) ?? '';
              if (_birthController.text.isEmpty && _initialBirth.isNotEmpty) {
                _birthController.text = _initialBirth;
              }
              // Do not overwrite the user's partial input from the bloc on every
              // rebuild. The DateFormatField widget will handle displaying the
              // initial value via `initialDate` and report completed input via
              // `onComplete`. Removing controller-based writes prevents the UI
              // from stomping user typing.

              final size = MediaQuery.of(context).size;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image(
                            image: (profile.photoUrl as String?) != null
                                ? NetworkImage(profile.photoUrl as String)
                                : const AssetImage(AppAssets.defaultAvatar)
                                      as ImageProvider,
                            width: size.width * 0.3,
                            height: size.width * 0.3,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 24),

                        _buildProfileField(
                          label: 'Full Name',
                          controller: _nameController,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date of Birth',
                                style: TextStyle(
                                  color: Color(0xFF5A3527),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF2B2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DateFormatField(
                                  // type2 gives format 23/10/2022 (full year, slashes)
                                  type: DateFormatType.type2,
                                  // Derive an initial DateTime to show in the field.
                                  // Prefer `birthFormatted` (dd/MM/yyyy). If absent, try
                                  // `birthRaw` which may be stored as yyyy-MM-dd or
                                  // as 8-digit ddMMyyyy; this makes the UI resilient to
                                  // different stored shapes.
                                  initialDate: (() {
                                    try {
                                      final String formatted =
                                          (profile.birthFormatted as String?) ??
                                          '';
                                      if (formatted.isNotEmpty) {
                                        try {
                                          return DateFormat(
                                            'dd/MM/yyyy',
                                          ).parse(formatted);
                                        } catch (_) {
                                          // fallthrough to try birthRaw
                                        }
                                      }

                                      final String raw =
                                          (profile.birthRaw as String?) ?? '';
                                      if (raw.isEmpty) return null;

                                      // yyyy-MM-dd
                                      final ymd = RegExp(
                                        r'^(\d{4})-(\d{2})-(\d{2})$',
                                      );
                                      final m = ymd.firstMatch(raw);
                                      if (m != null) {
                                        final y = int.parse(m.group(1)!);
                                        final mo = int.parse(m.group(2)!);
                                        final d = int.parse(m.group(3)!);
                                        return DateTime(y, mo, d);
                                      }

                                      // numeric ddMMyyyy
                                      final digits = RegExp(r'^(\d{8})$');
                                      if (digits.hasMatch(raw)) {
                                        final d = int.parse(
                                          raw.substring(0, 2),
                                        );
                                        final mo = int.parse(
                                          raw.substring(2, 4),
                                        );
                                        final y = int.parse(
                                          raw.substring(4, 8),
                                        );
                                        return DateTime(y, mo, d);
                                      }

                                      // last-ditch: try general parse
                                      try {
                                        return DateTime.parse(raw);
                                      } catch (_) {}
                                    } catch (_) {}
                                    return null;
                                  })(),
                                  addCalendar: false,
                                  controller: _birthController,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onComplete: (date) {
                                    // When the field is complete it returns a DateTime.
                                    // We dispatch the display-formatted string (dd/MM/yyyy)
                                    // to the bloc so UI and storage logic remain consistent.
                                    if (date != null) {
                                      final formatted = DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(date);
                                      try {
                                        context.read<MyProfileBloc>().add(
                                          BirthInputChanged(formatted),
                                        );
                                      } catch (_) {}
                                    } else {
                                      try {
                                        context.read<MyProfileBloc>().add(
                                          BirthInputChanged(''),
                                        );
                                      } catch (_) {}
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email',
                                style: TextStyle(
                                  color: Color(0xFF5A3527),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF2B2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  (profile.email as String?) ?? 'No email',
                                  style: const TextStyle(
                                    color: Color(0xFF5A3527),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        _buildProfileField(
                          label: 'Phone Number',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: 18),

                        AppBtnWidget(
                          text: 'Update Profile',
                          bgColor: primaryColor,
                          textColor: Colors.white,
                          onTap: () => context.read<MyProfileBloc>().add(
                            UpdateProfileRequested(
                              name: _nameController.text.trim().isEmpty
                                  ? null
                                  : _nameController.text.trim(),
                              phone: _phoneController.text.trim().isEmpty
                                  ? null
                                  : _phoneController.text.trim(),
                              birthRaw: (() {
                                final String _b =
                                    (profile.birthFormatted as String?) ?? '';
                                return _b.trim().isEmpty ? null : _b.trim();
                              })(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF5A3527),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2B2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              inputFormatters: inputFormatters,
              keyboardType: keyboardType,
              onChanged: (val) {
                if (label == 'Date of Birth') {
                  try {
                    context.read<MyProfileBloc>().add(BirthInputChanged(val));
                  } catch (_) {}
                }
              },
              style: const TextStyle(color: Color(0xFF5A3527), fontSize: 16),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
