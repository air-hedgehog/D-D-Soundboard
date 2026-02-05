import 'package:get_it/get_it.dart';

import 'db/database.dart';


GetIt getIt = GetIt.instance;

Future<void> initDI() async {
  getIt.registerSingleton<AppDatabase>(AppDatabase());
}