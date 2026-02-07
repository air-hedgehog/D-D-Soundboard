import 'package:cross_file/cross_file.dart';

class SoundModel {
  final String uuid;
  final String displayName;
  final XFile? image;
  final XFile sound;
  int index;
  double volume;

  SoundModel({
    required this.uuid,
    required this.image,
    required this.sound,
    required this.index,
    required this.displayName,
    required this.volume,
  });

  @override
  int get hashCode {
    return uuid.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return other is SoundModel && other.uuid == this.uuid;
  }
}

class ToAddEntry {
  XFile? image;
  final XFile sound;
  final String displayName;

  ToAddEntry({
    required this.image,
    required this.sound,
    required this.displayName,
  });
}
