import 'package:d_n_d_soundboard/home_screen/sound_instance.dart';
import 'package:d_n_d_soundboard/home_screen/sound_model.dart';

class SoundManager {

  SoundManager(this.onStop);

  final Function() onStop;
  final Map<String, SoundInstance> sounds = {};

  Future<SoundInstance> playFile(
    SoundModel model, {
    double volume = 100,
    bool loop = false,
  }) async {
    final sound = await SoundInstance.create(
      model.sound.path,
      volume: volume,
      loop: loop,
    );

    sounds[model.uuid] = sound;

    // Auto-remove when finished (if not looping)
    sound.completed.listen((done) async {
      if (done && !sound.isLooping) {
        await sound.dispose();
        sounds.remove(model.uuid);
        onStop();
      }
    });

    return sound;
  }
  
  Future<void> toggleLoop(SoundModel model) async {
    await sounds[model.uuid]?.setLooping(!sounds[model.uuid]!.isLooping);
  }
  
  Future<void> stop(SoundModel model) async {
    await sounds[model.uuid]?.stop();
    sounds.remove(model.uuid);
  }

  Future<void> stopAll() async {
    for (final s in sounds.values) {
      await s.stop();
    }
    sounds.clear();
  }

  Future<void> disposeAll() async {
    for (final s in sounds.values) {
      await s.dispose();
    }
    sounds.clear();
  }
}
