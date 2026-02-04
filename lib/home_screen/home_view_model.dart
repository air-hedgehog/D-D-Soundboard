import 'dart:async';
import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:d_n_d_soundboard/db/database.dart';
import 'package:d_n_d_soundboard/di.dart';
import 'package:d_n_d_soundboard/home_screen/sound_model.dart';
import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:view_model/view_model.dart';

import 'home_state.dart';

class HomeViewModel extends AbstractViewModel<HomeState> {
  HomeViewModel()
    : super(HomeState(loading: false, items: [], infinitePlayersUuids: {}));

  final SoLoud _soloud = SoLoud.instance;
  final AppDatabase _database = getIt<AppDatabase>();
  final Map<String, AudioSource> sources = {};
  final Map<String, SoundHandle> plays = {};
  final Map<String, StreamSubscription> events = {};

  @override
  void getState() async {
    await _initAudio();
    await refresh();
  }

  Future<void> _initAudio() async {
    final cacheDir = await getTemporaryDirectory();
    final soloudTemp = Directory('${cacheDir.path}/SoLoudLoader-Temp-Files');

    if (!await soloudTemp.exists()) {
      await soloudTemp.create(recursive: true);
    }

    await _soloud.init();
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

    for (var item in currentState.items) {
      sources[item.uuid] = await SoLoud.instance.loadFile(item.sound.path);
      events[item.uuid] = sources[item.uuid]!.soundEvents.listen((event) async {
        if (event.event == SoundEventType.handleIsNoMoreValid) {
          plays.remove(item.uuid);
          updateState(currentState);
          if (currentState.infinitePlayersUuids.contains(item.uuid)) {
            plays[item.uuid] = await SoLoud.instance.play(sources[item.uuid]!);
          }
        }
      });
    }

    updateState(currentState.apply(loading: false));
  }

  @override
  void dispose() async {
    super.dispose();
    for (var source in sources.values) {
      await SoLoud.instance.disposeSource(source);
    }
  }

  Future<void> togglePlay(SoundModel model) async {
    if (plays.containsKey(model.uuid)) {
      SoLoud.instance.pauseSwitch(plays[model.uuid]!);
    } else {
      plays[model.uuid] = await SoLoud.instance.play(sources[model.uuid]!);
    }

    updateState(currentState);
  }

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

  void stop(SoundModel model) async { 
    currentState.infinitePlayersUuids.remove(model.uuid);
    await SoLoud.instance.stop(plays[model.uuid]!);
    //plays.remove(model.uuid);
  }
}
