import 'package:media_kit/media_kit.dart';

class SoundInstance {
  final Player _player;
  bool _disposed = false;

  SoundInstance._(this._player);

  static Future<SoundInstance> create(
    String path, {
    double volume = 100,
    bool loop = false,
  }) async {
    final player = Player(configuration: const PlayerConfiguration());

    await player.setVolume(volume);

    if (loop) {
      await player.setPlaylistMode(PlaylistMode.loop);
    }

    await player.open(Media(path), play: true);

    return SoundInstance._(player);
  }

  Stream<bool> get playingStream => _player.stream.playing;

  bool get isPlaying => _player.state.playing;
  bool get isPaused => !_player.state.playing && !_player.state.completed;
  bool get isStopped => _player.state.completed;
  bool get isLooping => _player.state.playlistMode == PlaylistMode.loop;
  double get getVolume => _player.state.volume;

  Future<void> pause() async {
    if (_disposed) return;
    await _player.pause();
  }

  Future<void> resume() async {
    if (_disposed) return;
    await _player.play();
  }

  Future<void> stop() async {
    if (_disposed) return;
    await _player.stop();
  }

  Future<void> setLooping(bool loop) async {
    if (_disposed) return;
    await _player.setPlaylistMode(loop ? PlaylistMode.loop : PlaylistMode.none);
  }

  Future<void> setVolume(double volume) async {
    if (_disposed) return;
    await _player.setVolume(volume);
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    await _player.dispose();
  }

  Stream<bool> get completed => _player.stream.completed;
}
