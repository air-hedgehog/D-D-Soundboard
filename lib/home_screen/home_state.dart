import 'package:annotation/annotation.dart';
import 'package:d_n_d_soundboard/home_screen/sound_model.dart';

part 'home_state.g.dart';

@ViewModelStateAnnotation()
class HomeState {
  final bool loading;
  final List<SoundModel> items;

  HomeState({required this.loading, required this.items});
}