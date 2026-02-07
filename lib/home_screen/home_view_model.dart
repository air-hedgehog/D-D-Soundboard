import 'dart:async';
import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:d_n_d_soundboard/db/database.dart';
import 'package:d_n_d_soundboard/di.dart';
import 'package:d_n_d_soundboard/home_screen/sound_manager.dart';
import 'package:d_n_d_soundboard/home_screen/sound_model.dart';
import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:view_model/view_model.dart';

import 'home_state.dart';

class HomeViewModel extends AbstractViewModel<HomeState> {
  HomeViewModel() : super(HomeState(loading: false, items: []));

  final AppDatabase _database = getIt<AppDatabase>();
  late SoundManager manager;

  @override
  void getState() async {
    manager = SoundManager(() {
      updateState(currentState);
    });
    await refresh();
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
          image: e.imagePath == null ? null : XFile(e.imagePath!),
          sound: XFile(e.soundPath),
          index: e.index,
          displayName: e.displayName,
          volume: e.volume ?? 1.0,
        ),
      ),
    );

    updateState(currentState.apply(loading: false));
  }

  Future<void> togglePlay(SoundModel model) async {
    if (manager.sounds.containsKey(model.uuid)) {
      if (manager.sounds[model.uuid]!.isPlaying) {
        await manager.sounds[model.uuid]!.pause();
      } else {
        await manager.sounds[model.uuid]!.resume();
      }
    } else {
      await manager.playFile(model, volume: model.volume * 100.0);
    }

    updateState(currentState);
  }

  Future<void> deleteEntry(SoundModel model) async {
    updateState(currentState.apply(loading: true));

    manager.stop(model);

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

  Future<void> saveNewOrder(List<dynamic> newItems) async {
    for (int i = 0; i < newItems.length; i++) {
      newItems[i].index = i;
      await _database
          .into(_database.dBSoundModel)
          .insertOnConflictUpdate(
            DBSoundModelCompanion.insert(
              index: newItems[i].index,
              uuid: newItems[i].uuid,
              soundPath: (newItems[i] as SoundModel).sound.path,
              displayName: newItems[i].displayName,
              imagePath: Value((newItems[i] as SoundModel).image?.path),
              volume: Value(newItems[i].volume),
            ),
          );
    }
    await refresh();
  }

  Future<void> toggleInfinite(SoundModel model) async {
    if (!manager.sounds.containsKey(model.uuid)) {
      return;
    }
    await manager.toggleLoop(model);
    updateState(currentState);
  }

  void stop(SoundModel model) async {
    await manager.stop(model);
    updateState(currentState);
  }

  Future<void> setVolume(SoundModel model, double volume) async {
    await manager.setVolume(model, volume * 100.0);
    int? index = currentState.items.indexOf(model);
    if (index >= 0) {
      currentState.items[index].volume = volume;
      updateState(currentState);
      _database
          .into(_database.dBSoundModel)
          .insertOnConflictUpdate(
            DBSoundModelCompanion.insert(
              index: model.index,
              uuid: model.uuid,
              soundPath: model.sound.path,
              displayName: model.displayName,
              imagePath: Value(model.image?.path),
              volume: Value(model.volume),
            ),
          );
    }
  }
}
