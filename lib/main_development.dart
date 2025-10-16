import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:take_eat/app/app.dart';
import 'package:take_eat/bootstrap.dart';
import 'package:take_eat/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //TODO: Fix this too
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await bootstrap(() => const App());
}
