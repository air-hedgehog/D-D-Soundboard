import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:d_n_d_soundboard/db/database.dart';
import 'package:d_n_d_soundboard/di.dart';
import 'package:d_n_d_soundboard/home_screen/sound_model.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
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
}
