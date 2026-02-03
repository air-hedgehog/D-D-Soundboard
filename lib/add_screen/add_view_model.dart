import 'package:view_model/view_model.dart';
import 'add_state.dart';

class AddViewModel extends AbstractViewModel<AddState> {
  AddViewModel() : super(AddState(loading: false));

  @override
  void getState() {
    // TODO: Implement state fetching logic
  }
}
