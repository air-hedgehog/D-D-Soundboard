import 'dart:async';
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
  HomeViewModel()
    : super(HomeState(loading: false, items: [], infinitePlayersUuids: {}));

  final AppDatabase _database = getIt<AppDatabase>();
  final Map<String, AudioPlayer> players = {};

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
          image: e.imagePath == null ? null : XFile(e.imagePath!),
          sound: XFile(e.soundPath),
          index: e.index,
          displayName: e.displayName,
        ),
      ),
    );
    List<String> keys = [...players.keys];
    for (String key in keys) {
      if (!currentState.items.any((e) => e.uuid == key)) {
        players[key]?.dispose();
        players.remove(key);
      }
    }
    for (var item in currentState.items) {
      if (!players.containsKey(item.uuid)) {
        players[item.uuid] = AudioPlayer()..setFilePath(item.sound.path);
      }
    }
    updateState(currentState.apply(loading: false));
  }

  Future<void> togglePlay(SoundModel model) async {
    //debugPrint(players[model.uuid]!.getPlayerState());

    if (players[model.uuid]!.playerState.playing) {
      await players[model.uuid]!.pause();
    } else {
      //playLoop(players[model.uuid]!, model);
      await players[model.uuid]!.play();
      players[model.uuid]!.setLoopMode(LoopMode.one);
    }

    updateState(currentState);
  }

  // Future<void> playLoop(AudioPlayer player, SoundModel model) async {
  //   players[model.uuid]!.play();
  //   await player.startPlayer(
  //     fromURI: model.sound.path,
  //     whenFinished: () async {
  //       if (player.isOpen() && currentState.infinitePlayersUuids.contains(model.uuid)) {
  //         await playLoop(player, model);
  //       }
  //     },
  //   );
  // }

  Future<void> deleteEntry(SoundModel model) async {
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
            ),
          );
    }
    await refresh();
  }

  Future<void> toggleInfinite(SoundModel model) async {
    if (currentState.infinitePlayersUuids.contains(model.uuid)) {
      currentState.infinitePlayersUuids.remove(model.uuid);
    } else {
      currentState.infinitePlayersUuids.add(model.uuid);
    }
    updateState(currentState);
  }
}
