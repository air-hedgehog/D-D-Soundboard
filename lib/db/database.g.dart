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
  static const VerificationMeta _soundNameMeta = const VerificationMeta(
    'soundName',
  );
  @override
  late final GeneratedColumn<String> soundName = GeneratedColumn<String>(
    'soundName',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageNameMeta = const VerificationMeta(
    'imageName',
  );
  @override
  late final GeneratedColumn<String> imageName = GeneratedColumn<String>(
    'imageName',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [uuid, index, soundName, imageName];
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
    if (data.containsKey('soundName')) {
      context.handle(
        _soundNameMeta,
        soundName.isAcceptableOrUnknown(data['soundName']!, _soundNameMeta),
      );
    } else if (isInserting) {
      context.missing(_soundNameMeta);
    }
    if (data.containsKey('imageName')) {
      context.handle(
        _imageNameMeta,
        imageName.isAcceptableOrUnknown(data['imageName']!, _imageNameMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
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
      soundName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}soundName'],
      )!,
      imageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}imageName'],
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
  final String soundName;
  final String? imageName;
  const DBSoundModelData({
    required this.uuid,
    required this.index,
    required this.soundName,
    this.imageName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['index'] = Variable<int>(index);
    map['soundName'] = Variable<String>(soundName);
    if (!nullToAbsent || imageName != null) {
      map['imageName'] = Variable<String>(imageName);
    }
    return map;
  }

  DBSoundModelCompanion toCompanion(bool nullToAbsent) {
    return DBSoundModelCompanion(
      uuid: Value(uuid),
      index: Value(index),
      soundName: Value(soundName),
      imageName: imageName == null && nullToAbsent
          ? const Value.absent()
          : Value(imageName),
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
      soundName: serializer.fromJson<String>(json['soundName']),
      imageName: serializer.fromJson<String?>(json['imageName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'index': serializer.toJson<int>(index),
      'soundName': serializer.toJson<String>(soundName),
      'imageName': serializer.toJson<String?>(imageName),
    };
  }

  DBSoundModelData copyWith({
    String? uuid,
    int? index,
    String? soundName,
    Value<String?> imageName = const Value.absent(),
  }) => DBSoundModelData(
    uuid: uuid ?? this.uuid,
    index: index ?? this.index,
    soundName: soundName ?? this.soundName,
    imageName: imageName.present ? imageName.value : this.imageName,
  );
  DBSoundModelData copyWithCompanion(DBSoundModelCompanion data) {
    return DBSoundModelData(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      index: data.index.present ? data.index.value : this.index,
      soundName: data.soundName.present ? data.soundName.value : this.soundName,
      imageName: data.imageName.present ? data.imageName.value : this.imageName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DBSoundModelData(')
          ..write('uuid: $uuid, ')
          ..write('index: $index, ')
          ..write('soundName: $soundName, ')
          ..write('imageName: $imageName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(uuid, index, soundName, imageName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DBSoundModelData &&
          other.uuid == this.uuid &&
          other.index == this.index &&
          other.soundName == this.soundName &&
          other.imageName == this.imageName);
}

class DBSoundModelCompanion extends UpdateCompanion<DBSoundModelData> {
  final Value<String> uuid;
  final Value<int> index;
  final Value<String> soundName;
  final Value<String?> imageName;
  final Value<int> rowid;
  const DBSoundModelCompanion({
    this.uuid = const Value.absent(),
    this.index = const Value.absent(),
    this.soundName = const Value.absent(),
    this.imageName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DBSoundModelCompanion.insert({
    required String uuid,
    required int index,
    required String soundName,
    this.imageName = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       index = Value(index),
       soundName = Value(soundName);
  static Insertable<DBSoundModelData> custom({
    Expression<String>? uuid,
    Expression<int>? index,
    Expression<String>? soundName,
    Expression<String>? imageName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (index != null) 'index': index,
      if (soundName != null) 'soundName': soundName,
      if (imageName != null) 'imageName': imageName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DBSoundModelCompanion copyWith({
    Value<String>? uuid,
    Value<int>? index,
    Value<String>? soundName,
    Value<String?>? imageName,
    Value<int>? rowid,
  }) {
    return DBSoundModelCompanion(
      uuid: uuid ?? this.uuid,
      index: index ?? this.index,
      soundName: soundName ?? this.soundName,
      imageName: imageName ?? this.imageName,
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
    if (soundName.present) {
      map['soundName'] = Variable<String>(soundName.value);
    }
    if (imageName.present) {
      map['imageName'] = Variable<String>(imageName.value);
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
          ..write('soundName: $soundName, ')
          ..write('imageName: $imageName, ')
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
      required String soundName,
      Value<String?> imageName,
      Value<int> rowid,
    });
typedef $$DBSoundModelTableUpdateCompanionBuilder =
    DBSoundModelCompanion Function({
      Value<String> uuid,
      Value<int> index,
      Value<String> soundName,
      Value<String?> imageName,
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

  ColumnFilters<String> get soundName => $composableBuilder(
    column: $table.soundName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageName => $composableBuilder(
    column: $table.imageName,
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

  ColumnOrderings<String> get soundName => $composableBuilder(
    column: $table.soundName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageName => $composableBuilder(
    column: $table.imageName,
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

  GeneratedColumn<String> get soundName =>
      $composableBuilder(column: $table.soundName, builder: (column) => column);

  GeneratedColumn<String> get imageName =>
      $composableBuilder(column: $table.imageName, builder: (column) => column);
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
                Value<String> soundName = const Value.absent(),
                Value<String?> imageName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DBSoundModelCompanion(
                uuid: uuid,
                index: index,
                soundName: soundName,
                imageName: imageName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required int index,
                required String soundName,
                Value<String?> imageName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DBSoundModelCompanion.insert(
                uuid: uuid,
                index: index,
                soundName: soundName,
                imageName: imageName,
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
