import 'package:d_n_d_soundboard/home_screen/sound_model.dart';
import 'package:view_model/view_model.dart';

import 'home_state.dart';
import 'package:uuid/uuid.dart';

class HomeViewModel extends AbstractViewModel<HomeState> {
  HomeViewModel() : super(HomeState(loading: false, items: []));

  @override
  void getState() {
  }
}
