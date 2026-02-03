import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class DBSoundModel extends Table {
  TextColumn get uuid => text().named("uuid")();

  IntColumn get index => integer().named("index")();

  TextColumn get soundName => text().named("soundName")();

  TextColumn get imageName => text().named("imageName").nullable()();
}

@DriftDatabase(tables: [DBSoundModel])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'dnd_soundboard_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
