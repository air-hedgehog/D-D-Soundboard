import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:d_n_d_soundboard/db/database.dart';
import 'package:d_n_d_soundboard/di.dart';
import 'package:d_n_d_soundboard/home_screen/sound_model.dart';
import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:view_model/view_model.dart';

import 'home_state.dart';

class HomeViewModel extends AbstractViewModel<HomeState> {
  HomeViewModel() : super(HomeState(loading: false, items: []));

  final AppDatabase _database = getIt<AppDatabase>();

  @override
  void getState() {
    refresh();
  }

  Future<void> refresh() async {
    updateState(currentState.apply(loading: true));
    List<DBSoundModelData> allItems = await _database
        .select(_database.dBSoundModel)
        .get();
    allItems.sort((a, b) => a.index.compareTo(b.index));
    currentState.items.clear();
    currentState.items.addAll(
      allItems.map(
        (e) => SoundModel(
          uuid: e.uuid,
          image: e.imagePath == null
              ? null
              : XFile(e.imagePath!),
          sound: XFile(e.soundPath),
          index: e.index,
          displayName: e.displayName,
        ),
      ),
    );
    updateState(currentState.apply(loading: false));
  }

  void deleteEntry(SoundModel model) async {

    updateState(currentState.apply(loading: true));

    try {
      File(model.sound.path).delete();
    } on FileSystemException catch (e) {
      debugPrint("cannot delete sound file: $e");
    }

    if (model.image != null) {
      try {
        File(model.image!.path).delete();
      } on FileSystemException catch (e) {
        debugPrint("cannot delete image file: $e");
      }
    }

    await (_database.delete(
      _database.dBSoundModel,
    )..where((t) => t.uuid.equals(model.uuid))).go();
    await refresh();

    updateState(currentState.apply(loading: false));
  }

  void saveNewOrder(List<dynamic> newItems) async {
    for (int i = 0; i < newItems.length; i++) {
      newItems[i].index = i;
      await _database.into(_database.dBSoundModel).insertOnConflictUpdate(DBSoundModelCompanion.insert(
        index: newItems[i].index,
        uuid: newItems[i].uuid,
        soundPath: (newItems[i] as SoundModel).sound.path,
        displayName: newItems[i].displayName,
        imagePath: Value((newItems[i] as SoundModel).image?.path),
      ));
    }
    await refresh();
  }
}
