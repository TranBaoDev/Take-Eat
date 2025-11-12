@override
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_eat/core/asset/app_assets.dart';
import 'package:take_eat/core/asset/app_svgs.dart';
import 'package:take_eat/core/theme/app_colors.dart';
import 'package:take_eat/l10n/l10n.dart';
import 'package:take_eat/features/notification/bloc/notifi_bloc.dart';
import 'package:take_eat/features/notification/model/notification_item.dart';

class NotificationDrawer extends StatefulWidget {
  const NotificationDrawer({super.key});

  @override
  State<NotificationDrawer> createState() => _NotificationDrawerState();
}

class _NotificationDrawerState extends State<NotificationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SvgPictureWidget(
                    assetName: SvgsAsset.iconNotifiDrawer,
                    width: 28,
                    height: 28,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    context as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(
                color: AppColors.dividerColor,
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Notification list from bloc
          Expanded(
            child: BlocBuilder<NotifiBloc, NotifiState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const Center(
                    child: Text(
                      'No notifications',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  loaded: (items) => _buildList(context, items),
                  error: (msg) => Center(
                    child: Text(
                      msg,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<NotificationItem> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text('No notifications', style: TextStyle(color: Colors.white)),
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(color: AppColors.dividerColor),
      itemBuilder: (context, index) {
        final n = items[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SizedBox(
            width: 40,
            height: 40,
            child: AppAssetImageWidget(name: n.assetName),
          ),
          title: Text(
            _localizedMessage(context, n),
            style: const TextStyle(
              fontFamily: 'LeagueSpartan',
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }

  String _localizedMessage(BuildContext context, NotificationItem n) {
    final l10n = context.l10n;
    switch (n.status.toLowerCase()) {
      // case 'pending':
      //   return l10n
      //       .isPending; // e.g. 'One of your favorite is on promotion.' or appropriate string
      // case 'ongoing':
      //   return l10n.isOngoing;
      // case 'arrived':
      // case 'delivered':
      //   return l10n.isArrived;
      default:
        return n.message;
    }
  }
}
