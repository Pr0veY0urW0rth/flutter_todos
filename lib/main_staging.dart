import 'package:flutter/widgets.dart';
import 'package:flutter_todos/app/locator.dart';
import 'package:flutter_todos/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSharedPrefs.ensureInitialized();

  bootstrap();
}
