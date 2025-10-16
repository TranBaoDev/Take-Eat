import 'package:take_eat/app/app.dart';
import 'package:take_eat/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
