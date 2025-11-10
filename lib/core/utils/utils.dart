import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:take_eat/shared/data/model/product/product_model.dart';

enum ToastType { success, error, info }

void showToast(
  BuildContext context,
  String message, {
  ToastType type = ToastType.info,
  Duration duration = const Duration(seconds: 3),
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  final (icon, color) = switch (type) {
    ToastType.success => (Icons.check_circle_rounded, Colors.green),
    ToastType.error => (Icons.error_rounded, Colors.redAccent),
    ToastType.info => (Icons.info_rounded, Colors.blueAccent),
  };

  final snackBar = SnackBar(
    elevation: 6,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    duration: duration,
    content: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            child: const Icon(
              Icons.close_rounded,
              color: Colors.white70,
              size: 20,
            ),
          ),
        ],
      ),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<List<Product>> filterValidImages(List<Product> products) async {
  List<Future<bool>> checks = products.map((product) async {
    try {
      final resp = await http.head(Uri.parse(product.image));
      return resp.statusCode == 200 && (resp.headers['content-type'] ?? '').startsWith('image/');
    } catch (e) {
      return false;
    }
  }).toList();
  final results = await Future.wait(checks);
  return [for (int i = 0; i < products.length; i++) if (results[i]) products[i]];
}
