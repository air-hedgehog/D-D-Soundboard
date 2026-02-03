import 'package:cross_file/cross_file.dart';

class SoundModel {
  final String uuid;
  final XFile? image;
  final XFile sound;
  final int index;

  SoundModel({required this.uuid, required this.image, required this.sound, required this.index});
}

class ToAddEntry {
  XFile? image;
  final XFile sound;

  ToAddEntry({required this.image, required this.sound});
}
