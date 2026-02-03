import 'package:annotation/annotation.dart';

part 'add_state.g.dart';

@ViewModelStateAnnotation()
class AddState {
  final bool loading;

  AddState({required this.loading});
}
