import 'package:d_n_d_soundboard/db/database.dart';
import 'package:get_it/get_it.dart';


GetIt getIt = GetIt.instance;

Future<void> initDI() async {
  getIt.registerSingleton<AppDatabase>(AppDatabase());
}