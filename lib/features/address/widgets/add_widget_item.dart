import 'package:flutter/material.dart';
import 'package:take_eat/core/asset/app_svgs.dart';
import 'package:take_eat/shared/data/model/address/address.dart';

class AddressItemWidget extends StatelessWidget {
  const AddressItemWidget({
    required this.address,
    required this.onSelected,
    super.key,
  });
  final Address address;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final name =
        address.title ??
        address.fullAddress.split(', ').firstOrNull ??
        'Unknown';
    final detail = address.title != null
        ? address.fullAddress
        : (address.fullAddress.split(', ').skip(1).join(', ') ?? '');

    return ListTile(
      leading: const SvgPictureWidget(
        assetName: SvgsAsset.iconHouse,
        width: 27,
        height: 27,
      ),
      title: Text(name),
      subtitle: Text(detail),
      trailing: Radio<bool>(
        value: address.isSelected,
        groupValue:
            true, // Handle groupValue trong Bloc nếu cần chỉ một selected
        onChanged: (value) => onSelected(),
      ),
    );
  }
}
