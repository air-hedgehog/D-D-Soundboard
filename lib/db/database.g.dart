// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DBSoundModelTable extends DBSoundModel
    with TableInfo<$DBSoundModelTable, DBSoundModelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DBSoundModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _indexMeta = const VerificationMeta('index');
  @override
  late final GeneratedColumn<int> index = GeneratedColumn<int>(
    'index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _soundPathMeta = const VerificationMeta(
    'soundPath',
  );
  @override
  late final GeneratedColumn<String> soundPath = GeneratedColumn<String>(
    'soundPath',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'displayName',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'imagePath',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    index,
    soundPath,
    displayName,
    imagePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'd_b_sound_model';
  @override
  VerificationContext validateIntegrity(
    Insertable<DBSoundModelData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('index')) {
      context.handle(
        _indexMeta,
        index.isAcceptableOrUnknown(data['index']!, _indexMeta),
      );
    } else if (isInserting) {
      context.missing(_indexMeta);
    }
    if (data.containsKey('soundPath')) {
      context.handle(
        _soundPathMeta,
        soundPath.isAcceptableOrUnknown(data['soundPath']!, _soundPathMeta),
      );
    } else if (isInserting) {
      context.missing(_soundPathMeta);
    }
    if (data.containsKey('displayName')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['displayName']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('imagePath')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['imagePath']!, _imagePathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  DBSoundModelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DBSoundModelData(
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      index: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}index'],
      )!,
      soundPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}soundPath'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}displayName'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}imagePath'],
      ),
    );
  }

  @override
  $DBSoundModelTable createAlias(String alias) {
    return $DBSoundModelTable(attachedDatabase, alias);
  }
}

class DBSoundModelData extends DataClass
    implements Insertable<DBSoundModelData> {
  final String uuid;
  final int index;
  final String soundPath;
  final String displayName;
  final String? imagePath;
  const DBSoundModelData({
    required this.uuid,
    required this.index,
    required this.soundPath,
    required this.displayName,
    this.imagePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['index'] = Variable<int>(index);
    map['soundPath'] = Variable<String>(soundPath);
    map['displayName'] = Variable<String>(displayName);
    if (!nullToAbsent || imagePath != null) {
      map['imagePath'] = Variable<String>(imagePath);
    }
    return map;
  }

  DBSoundModelCompanion toCompanion(bool nullToAbsent) {
    return DBSoundModelCompanion(
      uuid: Value(uuid),
      index: Value(index),
      soundPath: Value(soundPath),
      displayName: Value(displayName),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
    );
  }

  factory DBSoundModelData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DBSoundModelData(
      uuid: serializer.fromJson<String>(json['uuid']),
      index: serializer.fromJson<int>(json['index']),
      soundPath: serializer.fromJson<String>(json['soundPath']),
      displayName: serializer.fromJson<String>(json['displayName']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'index': serializer.toJson<int>(index),
      'soundPath': serializer.toJson<String>(soundPath),
      'displayName': serializer.toJson<String>(displayName),
      'imagePath': serializer.toJson<String?>(imagePath),
    };
  }

  DBSoundModelData copyWith({
    String? uuid,
    int? index,
    String? soundPath,
    String? displayName,
    Value<String?> imagePath = const Value.absent(),
  }) => DBSoundModelData(
    uuid: uuid ?? this.uuid,
    index: index ?? this.index,
    soundPath: soundPath ?? this.soundPath,
    displayName: displayName ?? this.displayName,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
  );
  DBSoundModelData copyWithCompanion(DBSoundModelCompanion data) {
    return DBSoundModelData(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      index: data.index.present ? data.index.value : this.index,
      soundPath: data.soundPath.present ? data.soundPath.value : this.soundPath,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DBSoundModelData(')
          ..write('uuid: $uuid, ')
          ..write('index: $index, ')
          ..write('soundPath: $soundPath, ')
          ..write('displayName: $displayName, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(uuid, index, soundPath, displayName, imagePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DBSoundModelData &&
          other.uuid == this.uuid &&
          other.index == this.index &&
          other.soundPath == this.soundPath &&
          other.displayName == this.displayName &&
          other.imagePath == this.imagePath);
}

class DBSoundModelCompanion extends UpdateCompanion<DBSoundModelData> {
  final Value<String> uuid;
  final Value<int> index;
  final Value<String> soundPath;
  final Value<String> displayName;
  final Value<String?> imagePath;
  final Value<int> rowid;
  const DBSoundModelCompanion({
    this.uuid = const Value.absent(),
    this.index = const Value.absent(),
    this.soundPath = const Value.absent(),
    this.displayName = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DBSoundModelCompanion.insert({
    required String uuid,
    required int index,
    required String soundPath,
    required String displayName,
    this.imagePath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       index = Value(index),
       soundPath = Value(soundPath),
       displayName = Value(displayName);
  static Insertable<DBSoundModelData> custom({
    Expression<String>? uuid,
    Expression<int>? index,
    Expression<String>? soundPath,
    Expression<String>? displayName,
    Expression<String>? imagePath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (index != null) 'index': index,
      if (soundPath != null) 'soundPath': soundPath,
      if (displayName != null) 'displayName': displayName,
      if (imagePath != null) 'imagePath': imagePath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DBSoundModelCompanion copyWith({
    Value<String>? uuid,
    Value<int>? index,
    Value<String>? soundPath,
    Value<String>? displayName,
    Value<String?>? imagePath,
    Value<int>? rowid,
  }) {
    return DBSoundModelCompanion(
      uuid: uuid ?? this.uuid,
      index: index ?? this.index,
      soundPath: soundPath ?? this.soundPath,
      displayName: displayName ?? this.displayName,
      imagePath: imagePath ?? this.imagePath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (index.present) {
      map['index'] = Variable<int>(index.value);
    }
    if (soundPath.present) {
      map['soundPath'] = Variable<String>(soundPath.value);
    }
    if (displayName.present) {
      map['displayName'] = Variable<String>(displayName.value);
    }
    if (imagePath.present) {
      map['imagePath'] = Variable<String>(imagePath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DBSoundModelCompanion(')
          ..write('uuid: $uuid, ')
          ..write('index: $index, ')
          ..write('soundPath: $soundPath, ')
          ..write('displayName: $displayName, ')
          ..write('imagePath: $imagePath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DBSoundModelTable dBSoundModel = $DBSoundModelTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [dBSoundModel];
}

typedef $$DBSoundModelTableCreateCompanionBuilder =
    DBSoundModelCompanion Function({
      required String uuid,
      required int index,
      required String soundPath,
      required String displayName,
      Value<String?> imagePath,
      Value<int> rowid,
    });
typedef $$DBSoundModelTableUpdateCompanionBuilder =
    DBSoundModelCompanion Function({
      Value<String> uuid,
      Value<int> index,
      Value<String> soundPath,
      Value<String> displayName,
      Value<String?> imagePath,
      Value<int> rowid,
    });

class $$DBSoundModelTableFilterComposer
    extends Composer<_$AppDatabase, $DBSoundModelTable> {
  $$DBSoundModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get index => $composableBuilder(
    column: $table.index,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get soundPath => $composableBuilder(
    column: $table.soundPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DBSoundModelTableOrderingComposer
    extends Composer<_$AppDatabase, $DBSoundModelTable> {
  $$DBSoundModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get index => $composableBuilder(
    column: $table.index,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get soundPath => $composableBuilder(
    column: $table.soundPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DBSoundModelTableAnnotationComposer
    extends Composer<_$AppDatabase, $DBSoundModelTable> {
  $$DBSoundModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<int> get index =>
      $composableBuilder(column: $table.index, builder: (column) => column);

  GeneratedColumn<String> get soundPath =>
      $composableBuilder(column: $table.soundPath, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);
}

class $$DBSoundModelTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DBSoundModelTable,
          DBSoundModelData,
          $$DBSoundModelTableFilterComposer,
          $$DBSoundModelTableOrderingComposer,
          $$DBSoundModelTableAnnotationComposer,
          $$DBSoundModelTableCreateCompanionBuilder,
          $$DBSoundModelTableUpdateCompanionBuilder,
          (
            DBSoundModelData,
            BaseReferences<_$AppDatabase, $DBSoundModelTable, DBSoundModelData>,
          ),
          DBSoundModelData,
          PrefetchHooks Function()
        > {
  $$DBSoundModelTableTableManager(_$AppDatabase db, $DBSoundModelTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DBSoundModelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DBSoundModelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DBSoundModelTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<int> index = const Value.absent(),
                Value<String> soundPath = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DBSoundModelCompanion(
                uuid: uuid,
                index: index,
                soundPath: soundPath,
                displayName: displayName,
                imagePath: imagePath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required int index,
                required String soundPath,
                required String displayName,
                Value<String?> imagePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DBSoundModelCompanion.insert(
                uuid: uuid,
                index: index,
                soundPath: soundPath,
                displayName: displayName,
                imagePath: imagePath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DBSoundModelTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DBSoundModelTable,
      DBSoundModelData,
      $$DBSoundModelTableFilterComposer,
      $$DBSoundModelTableOrderingComposer,
      $$DBSoundModelTableAnnotationComposer,
      $$DBSoundModelTableCreateCompanionBuilder,
      $$DBSoundModelTableUpdateCompanionBuilder,
      (
        DBSoundModelData,
        BaseReferences<_$AppDatabase, $DBSoundModelTable, DBSoundModelData>,
      ),
      DBSoundModelData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DBSoundModelTableTableManager get dBSoundModel =>
      $$DBSoundModelTableTableManager(_db, _db.dBSoundModel);
}
