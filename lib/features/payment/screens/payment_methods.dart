import 'package:flutter/material.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Payment Methods',
      body: Center(
        child: Text('Payment Methods Screen'),
      ),
    );
  }
}
