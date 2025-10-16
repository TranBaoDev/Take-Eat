import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:take_eat/app/app.dart';
import 'package:take_eat/bootstrap.dart';
import 'package:take_eat/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await bootstrap(() => const App());
}
